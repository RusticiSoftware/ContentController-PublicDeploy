---
title: "Content Portal"
type: docs
menu: "main"
weight: 6
---

# Content Portal
Content Portal is a separate endpoint hosted within Content Controller for the purposes of allowing your customers 
access to download content dispatches. Setting up Content Portal is optional. This section covers the additional setup 
needed to host Content Portal. The information provided assumes you are hosting on AWS with Cloudfront.

## Email Requirement
Content Portal only authorizes users through a one-time-password sent via email. In order to use Content Portal, Content
Controller must have email enabled and set up. 

## Define a Content Portal Server Name
Where your Ansible playbook environment variables are stored, add the content portal main domain to 
`ContentPortalServerName`. Any additional aliases can be setup under `ContentPortalServerAliases`. Make sure the main 
domain follows the `*.portal.contentcontroller.*` naming convention.

## Provide Credentials
If the Content Portal server name shares the same subdomain as Content Portal and you have a wild card certificate you 
do not need to create a new certificate. Instead, create a new combined certificate. 

### Certificate Manager
Use Certificate Manager to request a new cert for `*.portal.contentcontroller.*`.

### Playbooks
You can generate your own key, certificate and SSL chain as an alternative to using Certificate Manager. Store those in 
the playbooks in your Ansible playbook environment variables.

## Update CloudFront
Add any additional alternate domain names that matches the name you've chosen. Also include any additional aliases you 
might have. Update the CloudFront Distribution to use the new certificate you generated earlier.

## Route 53
Point to the same CloudFront distribution. If you're not using CloudFront point to the same load balancer that 
you have setup for CC. Make sure to include a record for the base domain as well as any aliases.

## Modify your Load Balancer
Ensure that the certificates you have created accommodate the naming convention you've set in place for the server names 
and correctly resolve to that instance.


