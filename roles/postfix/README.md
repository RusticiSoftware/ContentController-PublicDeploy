# Postfix configuration

This role sets up postfix to use a smarthost for mail delivery.  Any old SMTP Smarthost that supports TLS on port 587 will work (which is to say pretty much all of them.)

You'll need to define vars for it - please see defaults/main.yml for the vars you'll need to add to your config.
