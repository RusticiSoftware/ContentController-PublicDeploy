# S3 and CloudFront

If you're running more than 1 server, you'll need a shared place to store your content.  For this, we recommend using AWS S3.  You could also use some sort of NFS if you'd like, but we provide application level support for S3.  To serve S3 course content, you'll also need to use CloudFront.  An additional benefit of CloudFront is that it lets us require authentication for accessing your course content, which prevents random users from being able to scan and download things from your S3 bucket.

CloudFront acts like a reverse proxy in front of your Content Controller application server and the S3 bucket that you use for storing course content. For most connections, it just passes the request through to your web tier. For course content requests, CloudFront authenticates the user via a signed cookie that the application generates, and if the user is allowed, it serves up the content from your S3 bucket.

CloudFront does all this while still appearing to have a DNS origin that is the same whether the content is coming from the web tier or the S3 bucket, which allows us to deliver SCORM content without violating cross-domain rules.

For more information, see the [S3](aws/S3.md) and [CloudFront](aws/CloudFront.md) sections of [Deploying in AWS](aws/AWS.md).  For alternatives to CloudFront and S3, take a look at the [Hosting at Scale](Infrastructure.md) section, or give us a call.

## Resources

[Serving Private Content In CloudFront](http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PrivateContent.html)

[Cookie Signing Information](http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-signed-cookies.html)
