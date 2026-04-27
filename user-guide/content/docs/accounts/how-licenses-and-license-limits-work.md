---
title: "How Licenses and License Limits Work"
type: docs
menu:
    main:
        name: How Licenses and License Limits Work
        identifier: how-licenses-and-license-limits-work
        parent: accounts
        weight: 3
---

# How licenses and license limits work

![](../.gitbook/assets/CC-LicenseLimits.png)

### **How Licenses Work**

A license in Content Controller is a set of usage limits with a descriptive name, such as "Annual" for a license that is limited to a single year, for one that is limited to 10,000 learners. A single license can have multiple limits, so you could also have a "10K learner annual" license that is valid for a single year and up to 10,000 learners. You can create a license while [creating an account](../getting-started/create-a-new-account.md#how-to-create-an-account), while [sharing content](sharing-content-out-to-an-account.md) with a limit-by-content account (described below), or ahead of time on the Licenses page of the Accounts section.

There are **three types of license limits** available in Content Controller:

1. **Duration/expiration:** This is a limit on the amount of time that content should remain available to learners. It is expressed as either a number of days (duration), or a fixed date (expiration), depending on whether the context is the license itself, or how the license applies to a particular account or content.
2. **Learners**: This is a limit on the number of learners who can access the content.
3. **Registrations**: This is a limit on the number of registrations that can be created. A new registration is created whenever a learner launches a course or equivalent for the first time.

Once a license has been defined, it can be attached to either an account as a whole or to individual content that has been shared with the account. Once attached, the license's limits can be edited without impacting any other account or content that uses the same license, allowing you to [extend](https://support.scorm.com/hc/en-us/articles/29736773015707-Content-Controller-Managing-License-Renewal) an existing license for a particular client.&#x20;

Multiple licenses can be attached to the same account or content, which is useful for handling [renewals](https://support.scorm.com/hc/en-us/articles/29736773015707-Content-Controller-Managing-License-Renewal), but only one license is active at any time. The active license is checked each time a learner launches content, to see if its limits have been reached. If not, then the launch is allowed to continue. Otherwise, the launch is halted with an error message for the learner.[1](https://docs.contentcontroller.com/user-guide/Accounts.html#fn_1)
