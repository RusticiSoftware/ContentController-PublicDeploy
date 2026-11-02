---
title: "Logs"
type: docs
menu:
    main:
        name: Where Are My Logs?
        identifier: logs
        parent: faq
        weight: 4
---

# Where Are My Logs?

Logs are located on the application servers.  We will ask for these during certain support issues, and they're helpful for you to see if something fishy is happening on your server.  Some important logs for Content Controller include:

* `/var/log/contentcontroller.log`
* `/var/log/scormengine.log`
* `/var/log/apache2/access.log`
* `/var/log/apache2/error.log`
* `/var/log/tomcat/*.log`

You should install some sort of agent to ship your logs somewhere where they are easier to search, store, and manage.  This is essential if you start using an autoscaling group.

A few easy-to-use options include:

* [Logz.io](https://logz.io)
* [Papertrail](https://papertrailapp.com)
