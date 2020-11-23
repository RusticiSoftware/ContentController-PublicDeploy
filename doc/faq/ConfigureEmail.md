# Configuring Email

Content Controller has the ability to send emails for certain events such as account licenses nearing their limits or password resets.  To enable this support, you'll need to use some sort of SMTP service.  You can use AWS SES, SendGrid, a Gmail account, or any other service that supports SMTP.  We've had pretty good luck with SendGrid.

To configure email:

1. Connect to your Ansible control server and navigate to the `ContentController-PublicDeploy` folder.
2. Edit `group_vars/content_controller.yml` and change `enable_emails: false` to `enable_emails: true`.
3. Fill in the rest of the relevant options for your email provider and save it.
4. Deploy Content Controller (see the [Installation Guide](../QuickStart.md)).

## Resources

[License Alert Emails in Content Controller](https://support.scorm.com/hc/en-us/articles/115003101773-License-Alert-Emails)

[Sending Email with Amazon SES](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/sending-email.html)

[Sending Email with SendGrid](https://sendgrid.com/solutions/email-api/)
