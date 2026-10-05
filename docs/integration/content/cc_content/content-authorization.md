---
title: "Content Authorization"
type: docs
menu:
    main:
        name: Content Authorization
        identifier: content_authorization
        parent: cc_content
        weight: 5
---

# Content Authorization

When a user views content, Content Controller needs to check if that user is authorized to view those files and has actually launched
the course. You can configure how this authorization happens to fit your needs.

## Content Vault

In 2019, browsers began phasing out third-party cookies. Since courses launched from Content Controller are generally 
loaded inside of an iframe, browsers assume the application is trying to monitor users with cookies, so the application's cookies get 
blocked. Previously, the application was using these cookies to authenticate access to content files, so there was a need for an
alternative solution. "Content Vault" is the term used to refer to this layer of cookieless content authorization.

When a user launches the course, the application will generate a unique URL path prefix with which they can access that course. This 
unique URL is only valid for a configurable length of time. In addition to that path, Content Vault can also record the IP address
and/or browser User-Agent when the content is launched. Then, on subsequent requests using the generated path, the application will
check that the requester's IP address and/or User-Agent is the same as the one that was used to launch the course.

Here is an example content-vaulted path:

```
https://my-example.contentcontroller.com/vault/87a24c13-dc0b-450a-940c-f3efb2133ec7/courses/7e480c43-45fd-48a0-8aba-d77a965ab052/0/shared/launchpage.html
```

Everything after `/courses/` points to the actual file, while the `/vault/87a24c13-dc0b-450a-940c-f3efb2133ec7` is
the Vault prefix. This GUID is randomly generated on launch.

For every request that includes this `/vault/` prefix, Content Controller will verify that the details of the request for 
content match the details of the original launch request.

This verification is performed using the Proxy/CDN layer through either Content Proxy or a function.

To configure Content Vault:

```
# Controls how we authorize learner launches to view content
# 'content_vault', 'cookies', or false
content_authorization: 'content_vault'
# What fields should we track from a learner to authorize their requests? (IP_ADDRESS, USER_AGENT)
# Note that these are not required to authorize launches. The Vault path alone can do that, but these
# allow you finer control to, for example, block a learner from accessing a content file from
# different computers at the same time.
content_vault_validate_fields: {
  "IP_ADDRESS": true,
  "USER_AGENT": true
}
# This is the maximum time at which a learner's launch will expire and they must re-launch.
content_vault_expiration_seconds: 3600
# This is how much time a learner can spend inactive before they have to re-launch. Any activity
# will refresh the expiration up to the max expiration in the setting above.
content_vault_sliding_window_seconds: 3600
# Should we deny requests to media files if they don't come from within a CC launch?
content_vault_inject_segment_media_files: true
```

### With Content Proxy

If you are using Content Proxy, Content Vault and Content Proxy will automatically configure themselves to work together.
They both simply need to be enabled.

Content Proxy, upon receiving a request, will take the Content Vault GUID and ask Content Controller to verify that GUID
matches a launch and that the user's request details match the expected learner before allowing it to continue.

{{< hint warning >}}
If you are using Content Proxy + Content Vault + S3, note that account assets are not vaulted and `/courses/assets/accounts/*`
requests must be allowed to reach the app or your file storage location (such as S3).
{{< /hint >}}

### With CloudFront or other

If you have something like CloudFront configured to serve requests to your content files, you can use that to verify
that the learners are authorized to view them using Vault. We will use CloudFront as an example here.

CloudFront receives the request, sees the `/vault/` prefix, and then calls our Lambda@Edge function. This function
analyzes the incoming request and asks Content Controller to verify that the details look right. Content Controller
checks the provided details and compares them to the values it has stored. If everything matches up, it returns a
successful response.

{{< hint tip >}}
To avoid overloading CC with these requests, it's recommended that you cache successful verification results
for a short time. That way, the next time Lambda tries to verify a request, it just reads the cached value. This
cache should only last as long as the Vault GUID remains valid.
{{< /hint >}}

To configure this (Using CloudFront)
- Go to your CloudFront distribution's behaviors
- Add a `/vault/*` behavior with the origin set to your file storage location
- On the `Origin Request` function, enter the ARN of your lambda function (see below for example)

*Example function for verifying Vault requests. You can adapt this function to your hosting setup:*

```
const path = require('path');
const https = require('https');
const querystring = require('querystring');

const CONFIG = {
    "APP_HOST": "abc.contentcontroller.com",
    "APP_PORT": 443,
    "APP_ROOT": "/ScormEngineInterface/"
}

const verifyContentRequest = function (guid, postData, request, verifyPath) {
    const uniquePortionOfPath = guid + '?' + querystring.stringify(postData);

    var options = {
        host: CONFIG.APP_HOST,
        port: CONFIG.APP_PORT,
        path: CONFIG.APP_ROOT + 'api/v2/plugin/contentVault/verify/' + uniquePortionOfPath,
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Host': CONFIG.APP_HOST
        }
    };

    // return new pending promise
    return new Promise((resolve, reject) => {
        var req = https.request(options, function (res) {
            res.setEncoding('utf8');
            // The /verify endpoint on Engine will return an error message we can show the learner
            let responseBody = "";
            res.on('data', function (chunk) {
                responseBody += chunk;
            });
            res.on('end', () => {
                if (res.statusCode === 403) {
                    console.log('forbidden: ' + responseBody);
                    resolve({
                        status: 403,
                        statusDescription: 'Forbidden',
                        body: 'You are not authenticated to access this content. Reason: ' + responseBody,
                        bodyEncoding: 'text'
                    });
                } else if (res.statusCode >= 400) {
                    console.log('problem with request: ' + responseBody);
                    resolve({
                        status: 500,
                        statusDescription: 'Internal Server Error',
                        body: 'An error was encountered authenticating access to course content.',
                        bodyEncoding: 'text'
                    });
                } else {
                    request.uri = verifyPath;
                    resolve(request);
                }
            });
        });

        req.on('error', function (e) {
            console.log('problem with request: ' + e.message);
            resolve({
                status: 500
            });
        });

        req.end();
    });
};

exports.handler = async (event, context) => {
    const request = event.Records[0].cf.request;

    /*
     * Example valid request URL:
     *
     *    /vault/1dd202ea-6dcd-47ae-81ae-787ec6fdf550/r-r/3/courses/my_course_id/0/index.html
     *
     * Let's break this down
     * - `/vault/{guid}` : this is the Vault record we need to check
     * - `/r-r` or just `/r` : "r-" indicates that referer-checking is enabled (you would need to implement this), a subequent or lone "r" indicates that this is a relative path.
     * - `3` : indicates the number of path parts until the root path of the content
     * - The remainder is the path to the course
     *
     * You can expect Vault requests to match this format.
     */
    var uri = request.uri;

    var pathParts = uri.split('/');
    var guid = pathParts[2];

    var urlType = pathParts[3] || "";
    var refererCheckSegment = false;

    var contentRootPathNumber = parseInt(pathParts[4]);

    // example: /courses/my_course_id/0/a/b/c/test.js
    var requestedFilePath = path.resolve('/', pathParts.slice(5).join('/'));

    // example: /courses/my_course_id
    var contentRoot = requestedFilePath.split('/').slice(0, contentRootPathNumber + 1).join('/');

    // Engine does not expect a leading slash on the path
    contentRoot = contentRoot.substring(1);

    const postData = {
        'contentPath': decodeURIComponent(contentRoot),
        'ipAddress': request.clientIp,
        'fingerprint': request.headers['user-agent'] ? request.headers['user-agent'][0].value : 'unknown',
    };

    return verifyContentRequest(guid, postData, request, requestedFilePath);
};
```

## Cloudfront-compatible Cookies

Alternatively, you can authorize content using cookies, the original way that Content Authorization was done.

On launch, Content Controller will create CloudFront-compatible cookies and attach them to a launch response.
When the learner then loads the content, CloudFront will use those cookies to verify that the learner
has launched the course and is authorized to view its content.

{{< hint warning >}}
Browsers interpret these as third-party cookies and will block them, preventing launches from working unless
the learner disables this in their browser.
{{< /hint >}}

To configure cookies, see the [self hosting CloudFront docs](/self-hosting/aws/cloudfront/) for **Signing Keys** and **Ansible Config**.

### With Content Proxy

Cookies work with Content Proxy out of the box.

### With CloudFront or other

Using CloudFront as an example:
- Go to your CloudFront distribution's behaviors
- Create a behavior for `/courses/*` with the origin set to your file storage location
- Enable `Restrict Viewer Access` and set `Trusted Signer` to `Self`

This will deny requests to content files unless the learner launched the course and received the authorization cookies.