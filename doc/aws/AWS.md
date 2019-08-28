# Initial Infrastructure Setup

This guide will go step-by-step through deploying Content Controller in a high availability setup to Amazon Web Services.  If you already know your way around AWS, feel free to just use this as a reference, and follow your own practices.  If you prefer to save some money and only deploy to one availability zone, that's fine - just skip the multi-AZ settings.

Create an AWS account. If you already have one, we'll create new Virtual Private Cloud for Content Controller to operate from.  Before you begin, make sure you have your [AWS account number](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html), your `keypair.yml` file (provided by Rustici), and access to your domain's DNS records.

## AWS Account Security

Take some time to review the [IAM Best Practices guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html).  It's a good idea to [lock down your root account](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#lock-away-credentials) and use an IAM user for yourself.  Also, consider using [AWS multi-factor authentication](https://aws.amazon.com/iam/details/mfa/) along with [Authy](https://authy.com/) or Google Authenticator.
