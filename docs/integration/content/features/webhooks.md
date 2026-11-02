---
title: "Webhooks"
type: docs
menu:
    main:
        name: Webhooks
        identifier: webhooks
        parent: features
        weight: 5
---


# Webhooks


## Introduction
Content Controller 4.0 introduced support for webhooks, which enables Content Controller to send notifications to a target system when certain events take place. Webhooks can be triggered by events that take place in the UI or through the Automation API, and the delivered messages will describe the event that happened. Where Content Controller will send these messages is referred to as the 'target' system and is configurable for each webhook.

The following sections will describe how to configure and enable Content Controller's Webhooks feature:

* [Setup](#setup): Describes the steps required to setup and configure the required message queues. This section is more important for those who are self-hosting Content Controller.
* [Content Controller Config](#config): Describes the Content Controller configuration settings that impact webhooks behavior. This section is more important for those who are self-hosting Content Controller.
* [Webhook Configuration](#webhookconfig): Describes the different ways webhooks can be configured
* [Postback Messages](#messages): Describes the postback messages Webhooks will deliver
* [Webhook Statistics](#statistics): Describes how to track a webhook's usage
* [How to Use](#use)

{{< line_break >}}
{{< line_break >}}

## Setup {#setup}
This section is more important for those who are self-hosting Content Controller. Content Controller incorporates some AWS products to support the scaling and ordering of the webhook's postback messages. At this time, you must have a valid AWS configuration to take advantage of the Webhooks feature. See the [AWS](/self-hosting/aws/aws) for more information.

Specifically, Content Controller relies on the AWS SQS service to handle the ordering and scaling of webhook messages. Content Controller relies on FIFO (first in, first out) queues to maintain the order of webhook message events. In order to enable the webhooks feature, Content Controller will need two SQS FIFO queues: (1) a message queue and (2) a dead-letter queue.

From Content Controller's perspective, the only requirement for the SQS queue is that the queue is of FIFO type. This selection is at the very top of the 'Create Queue' details section on AWS Console. It is strongly recommended that you enable the 'Dead Letter Queue' on the message queue to point to the dead-letter queue. NOTE: Content Controller's true number of attempts will be the smaller value between the SQS queue's redrive policy 'Maximum Receives' count and the specific webhook's `max_attempts` configuration. See [Retrying](#retrying) for more information.

One important thing to understand is that Content Controller should be the only application that is polling these queues for messages. If another application polls the queue and processes or deletes messages, Content Controller will be unable to send the webhook notification that corresponds with that message, which will result in lost webhook notifications.

With these two queues created, Content Controller will need to know the names of the queues in its configuration.

{{< line_break >}}

## Content Controller Configuration {#config}
This section is more important for those who are self-hosting Content Controller. After the creation of the message and dead-letter queues, open your `group_vars/content_controller.yml` configuration file in the Ansible playbooks. Find the placeholder values for these settings and update them to the following:

```
enable_webhooks_service: true
enable_queue_polling: false
message_queue_name: "{q_name.fifo}"
dead_letter_queue_name: "{dlq_name.fifo}"
queue_polling_interval: 10
webhooks_auth_secret: "{secret}"
```


`enable_webhooks_service` - This setting tells Content Controller to enable the triggering of webhook events. When disabled, Content Controller will not trigger any new webhook events, nor will it poll the SQS queue for any messages that are ready for delivery to the target system. When disabled, existing webhooks enter a 'Read Only' state, and can not be updated or deleted.


`enable_queue_polling` - This setting determines whether or not Content Controller will poll messages off the message queue. When this setting is disabled, Content Controller will still build postback messages when events that trigger webhook notifications happen. The messages will be sent to the queue, but Content Controller will ultimately not do anything with the messages once that happens. This setting can be used if you have another system you want to poll the message queue.


`queue_polling_interval` - Tells Content Controller how frequently, in seconds, it should poll the SQS queue for available messages. Content Controller utilizes long polling, which reduces the number of empty polls and returns messages as soon as they are available. The default interval value is 10 seconds.


`webhooks_auth_secret` - This is a 64-character string that is used in the process of encrypting and storing the webhook postback key and secret values in the database.

{{< line_break >}}

## Webhook Configuration {#webhookconfig}
When creating or updating a webhook, you must define certain properties that identify and direct the webhook's behavior. For these requests, you must define a webhook's `name`, `topic`, and `target_url`. There are many other properties that are optional. Here is an example schema that could be used to Create or Update a webhook:
```
{
    "name": "new webhook configuration",
    "topic": "ACCOUNT",
    "subtopics": [
        "ACCOUNT_DELETED"
    ],
    "focus": [
        {
            "webhook_focus_type": "ACCOUNT",
            "webhook_focus_id": 23,
            "webhook_focus_name": "Special Account"
        }
    ],
    "target_url": "https://target.system.com",
    "authentication": {
        "type": "BASIC",
        "key": "demoKey",
        "secret": "demoSecret"
    },
    "enabled": true
}
```
The above schema would create an active webhook named "new webhook configuration" that would trigger when the "Special Account" is deleted and would send a message to **`https://target.system.com`** with an Authorization header (with a basic auth string created with 'demoKey' and 'demoSecret').


Webhooks are not allowed to have an explicitly empty “subtopic” list. This is enforced: in the UI, by making a valid Subtopic selection a requirement when creating or updating a webhook, and in the Automation API, by rejecting requests that have an empty (`subtopics: []`) “subtopic” definition. NOTE: Automation API requests that have no explicitly defined “subtopic” definition will be interpreted as the full list of Subtopics.


For example, a `POST /webhooks` request with the following request schema would trigger notifications when an account is created, has its activation status updated, and deleted:
```
{
    "name": "Account Webhook with an explicitly empty Subtopics list",
    "target_url": "https://target.system.com",
    "topic": "ACCOUNT"
}
```


However, the following request is invalid:
```
{
    "name": "Account Webhook with an explicitly empty Subtopics list",
    "target_url": "https://target.system.com",
    "topic": "ACCOUNT",
    "subtopics": []
}
```


### Properties Accessible via API
There are a few webhook settings that are not presented in the UI and are only accessible via the Automation API. These include:


`max_attempts` - integer between 1 and 1000 that indicates the total number of times a webhook will try sending a postback message should the initial attempt fail.


`ignore_before_dt` - webhooks can be configured to ignore messages from events that were triggered before a specific point in time (ISO datetime). This property can be used should the message queue get significantly backed up via a configuration issue.


`logging_mode` - defines the level of detail the webhook should record in log statements. See the [Logging](#logging) section below for details.


### Supported Webhook Triggers
Webhook messages can be triggered by a variety of events. The broadest categories of those, referred to as Topics, include `ACCOUNT`, `ACCOUNT_CONTENT`, `COURSE`, and `REGISTRATION`. A Topic is required to be defined for every webhook. 


We also support Subtopics, which are more specific actions within a Topic. If defined, the webhook will trigger only for those Subtopics.


Here are the sets of topics with their associated Subtopics that can trigger webhook notifications in Content Controller:

* ACCOUNT
    * **Account created\***: A new account has been created in Content Controller.
    * **Account activation updated**: An account's activation status has been updated (the webhook notification message will indicate if the account is now 'active' or 'inactive').
    * **Account deleted**: An account has been deleted from Content Controller.

* ACCOUNT_CONTENT
    - **Content added to account**: A course, equivalent, or bundle has been added to an account.
    - **Content removed from account**: A course, equivalent, or bundle has been removed from an account.

* COURSE
    - **Course Imported\***: A new course has been imported to Content Controller's Global Content Pool.
    - **Course Version Uploaded**: A new version of a course has been uploaded to Content Controller.
    - **Course Version Published**: A course version has been published in the Global Content Pool.

* REGISTRATION
    - **Registration launched**: A new registration has been launched.
    - **Registration status updated**: The Completion, Success, or Score values for a registration have been updated.


\* availabilty of these Subtopics are impacted by the webhook's defined Focus. See the [Webhook Focus](#focus) section below for more details.


The webhook postback messages will describe the event that happened, as well as note any related assets. For details about what information is included in the postback messages for each event, see the [Message Schemas](#schemas) section below.



### Webhook Focus {#focus}
A webhook with an 'ACCOUNT_CONTENT' Topic would trigger when any piece of content is added or removed from any account. That may be intentional, but it would be very noisy for larger systems. 


Instead, it may be a good idea to pick a specific course or account to be the Focus of the webhook, and the postback messages will be filtered to only the events taken against those Content Controller assets. 


The following Focus options are available for each topic:

* `ACCOUNT` webhooks can be focused on specific accounts.
* `ACCOUNT_CONTENT` webhooks can be focused on specific accounts or specific content.
* `COURSE` webhooks can be focused on specific courses.
* `REGISTRATION` webhooks can be focused on specific accounts or specific content.


A webhook can focus on more than one type of asset, but then it must have both Focuses satisfied before a notification will be sent.


There is a Subtopic limitation when defining a webhook's Focus. Certain Subtopics don't apply when the webhook is focused on a specific asset. For example, a webhook that is focused on a specific account would never trigger for the 'Account Created' event. Similarly, a webhook focused on specific courses would never trigger for the 'Course Imported' event. Content Controller rejects attempts to configure webhooks with invalid Subtopic/Focus combinations.



### Logging {#logging}
The Content Controller logs can provide good insight when webhooks behave in an unexpected manner. Each webhook can be configured to change what gets logged at the INFO level which is the default level for Content Controller.


There are four available logging modes for each webhook:
* `NONE`: No log statements will be generated for events that impact this webhook.
* `SUMMARY`: Generate a minimal log that specifies the webhook event that occurred, the ID of the impacted webhook, and whether the event was successful or not.
* `FULL`: Same as `SUMMARY`, but also include the full webhook message body, and any response schemas, if applicable.
* `FULLONERROR`: treated as `SUMMARY` if the webhook event was successful and as `FULL` if webhook processing encountered an error.

By default, webhooks have the `FULLONERROR` logging mode.

If other configurations that impact logging are set for DEBUG logging, the webhook's logging level can be overridden. For example, if the class that triggers the webhook event is set to DEBUG logging (via the `cc_custom_log_levels` configuration), the impacted webhooks will log at the FULL level. Similarly, if Content Controller itself is set to DEBUG logging, all webhooks will generate FULL logs. However, a less-verbose logging level defined for the class or for Content Controller will not override a webhook's more-verbose logging level.


### Retrying {#retrying}
Should Content Controller encounter an issue in delivering the webhook notification message to the target system, it will attempt to retry the message processing. Each webhook has a `max_attempts` property that determines how many times Content Controller will attempt to send messages for that webhook. After attempting and failing to deliver the message `max_attempts` number of times, Content Controller will deliver the message to the configured Dead Letter Queue. Content Controller will make sure to update the webhook's statistics and create log messages that should describe the issue it encountered.


In addition to the webhook-specific configuration, the SQS message queue itself can specify how many times a message should be retried before being delivered to the Dead Letter Queue. This is known as the queue's Redrive Policy. NOTE: If the value of the SQS queue’s Redrive Policy is less, it can override the webhook's `max_attempts` setting. For example, if the webhook has a `max_attempts` value of 10, but the queue’s Redrive Policy is configured to attempt delivering messages 3 times, Content Controller will direct the message to the DLQ after 3 failed attempts. Content Controller's true number of attempts will be the smaller value between the SQS queue's Redrive Policy 'Maximum Receives' count and the specific webhook's `max_attempts` configuration.

{{< line_break >}}

## Postback Messages {#messages}
Webhooks are used to deliver notification messages to outside systems that can then act upon the received messages. When Content Controller triggers a webhook event, it will build up a message that describes the event and send a POST request to the target system at the `target_url` configured for the webhook. The request will include the webhook notification message as a JSON body on the request.


### Target System Authentication
At this time, Content Controller supports Basic Auth as an option for adding authorization to the webhook postback messages. Content Controller will build and include an Authorization header with the postback message, which the target system can then use to verify access and either allow or reject messages. Webhooks that are configured, either through the UI or API, with a 'Key' and 'Secret' will include that Authorization header with the postback message.


By default, webooks are configured with "NONE" authentication type. With this configuration, Content Controller will not include an Authorization header with the webhook postback message.


### Message Schemas {#schemas}
The following are examples of the webhook notification message payloads for each supported event.

Supported Webhook triggers:

* [Account Created](#account_created)
* [Account Activation Updated](#account_activation_updated)
* [Account Deleted](#account_deleted)
{{< line_break >}}
{{< line_break >}}
* [Content Added to Account](#content_added_to_account)
* [Content Removed from Account](#content_removed_from_account)
{{< line_break >}}
{{< line_break >}}
* [Course Imported](#course_imported)
* [Course Version Uploaded](#course_version_uploaded)
* [Course Version Published](#course_version_published)
{{< line_break >}}
{{< line_break >}}
* [Registration Launched](#registration_launched)
* [Registration Status Updated](#registration_status_updated)

{{< line_break >}}

#### Account Created {#account_created}
```
{
    "subscription_id": 2,
    "name": "demo-webhook",
    "topic": "ACCOUNT",
    "subtopic": "ACCOUNT_CREATED",
    "resource": {
        "account": {
            "id": 15073,
            "name": "demo-account-name",
            "enabled": true
        }
    },
    "user": "john.learner@organization.com",
    "timestamp": "2023-10-19T13:47:57.89698Z",
    "target_url": "https://target.system.com",
    "logging_mode": "FULL_ON_ERROR",
    "max_attempts": 1
}
```

#### Account Activation Updated {#account_activation_updated}
```
{
    "subscription_id": 2,
    "name": "demo-webhook",
    "topic": "ACCOUNT",
    "subtopic": "ACCOUNT_ACTIVATION_UPDATED",
    "resource": {
        "account": {
            "id": 15073,
            "name": "demo-account-name",
            "enabled": false
        }
    },
    "user": "john.learner@organization.com",
    "timestamp": "2023-10-19T13:48:01.325298Z",
    "target_url": "https://target.system.com",
    "logging_mode": "FULL_ON_ERROR",
    "max_attempts": 1
}
```

#### Account Deleted {#account_deleted}
```
{
    "subscription_id": 2,
    "name": "demo-webhook",
    "topic": "ACCOUNT",
    "subtopic": "ACCOUNT_DELETED",
    "resource": {
        "account": {
            "id": 15073,
            "name": "demo-account-name",
            "enabled": false
        }
    },
    "user": "john.learner@organization.com",
    "timestamp": "2023-10-19T13:49:12.407246Z",
    "target_url": "https://target.system.com",
    "logging_mode": "FULL_ON_ERROR",
    "max_attempts": 1
}
```

#### Content Added to Account {#content_added_to_account}
```
{
    "subscription_id": 2,
    "name": "demo-webhook",
    "topic": "ACCOUNT_CONTENT",
    "subtopic": "CONTENT_ADDED_TO_ACCOUNT",
    "resource": {
        "account": {
            "id": 15067,
            "name": "demo-account-name",
            "enabled": true
        },
        "content": {
            "folder": {
                "id": 1506,
                "name": "folder-with-equivalents",
                "location": "Home",
                "contents": [
                    {
                        "type": "EQUIVALENT",
                        "id": 6501,
                        "name": "demo-equiv"
                    },
                    {
                        "type": "EQUIVALENT",
                        "id": 6502,
                        "name": "demo-scorm12-equiv"
                    },
                    {
                        "type": "EQUIVALENT",
                        "id": 6503,
                        "name": "demo-scorm2004-3-equiv"
                    },
                    {
                        "type": "EQUIVALENT",
                        "id": 6504,
                        "name": "demo-scorm2004-4-equiv"
                    }
                ]
            }
        }
    },
    "user": "john.learner@organization.com",
    "timestamp": "2023-10-19T13:51:17.030713Z",
    "target_url": "https://target.system.com",
    "logging_mode": "FULL_ON_ERROR",
    "max_attempts": 1
}
```

#### Content Removed from Account {#content_removed_from_account}
```
{
    "subscription_id": 2,
    "name": "demo-webhook",
    "topic": "ACCOUNT_CONTENT",
    "subtopic": "CONTENT_REMOVED_FROM_ACCOUNT",
    "resource": {
        "account": {
            "id": 15067,
            "name": "demo-account-name",
            "enabled": true
        },
        "content": {
            "bundle": {
                "id": 3952,
                "name": "demo-content-with-interactions",
                "location": "Home"
            }
        }
    },
    "user": "john.user@organization.com",
    "timestamp": "2023-10-19T13:51:37.106559Z",
    "target_url": "https://target.system.com",
    "logging_mode": "FULL_ON_ERROR",
    "max_attempts": 1
}
```

#### Course Imported {#course_imported}
```
{
    "subscription_id": 2,
    "name": "demo-webhook",
    "topic": "COURSE",
    "subtopic": "COURSE_IMPORTED",
    "resource": {
        "content": {
            "course": {
                "id": 31230,
                "name": "Golf Explained - Run-time Advanced Calls",
                "version_id": 0,
                "learning_standard": "SCORM_2004_3RD_EDITION",
                "location": "Home > demo_content > nested_folder"
            }
        }
    },
    "user": "john.user@organization.com",
    "timestamp": "2023-10-19T13:53:33.74762Z",
    "target_url": "https://target.system.com",
    "logging_mode": "FULL_ON_ERROR",
    "max_attempts": 1
}
```

#### Course Version Uploaded {#course_version_uploaded}
```
{
    "subscription_id": 2,
    "name": "demo-webhook",
    "topic": "COURSE",
    "subtopic": "COURSE_VERSION_UPLOADED",
    "resource": {
        "content": {
            "course": {
                "id": 31230,
                "name": "Golf Explained - Run-time Advanced Calls",
                "version_id": 1,
                "learning_standard": "SCORM_2004_3RD_EDITION",
                "location": "Home > demo_content > nested_folder"
            }
        }
    },
    "user": "john.user@organization.com",
    "timestamp": "2023-10-19T13:53:52.625231Z",
    "target_url": "https://target.system.com",
    "logging_mode": "FULL_ON_ERROR",
    "max_attempts": 1
}
```

#### Course Version Published {#course_version_published}
```
{
    "subscription_id": 2,
    "name": "demo-webhook",
    "topic": "COURSE",
    "subtopic": "COURSE_VERSION_PUBLISHED",
    "resource": {
        "content": {
            "course": {
                "id": 31230,
                "name": "Golf Explained - Run-time Advanced Calls",
                "version_id": 1,
                "learning_standard": "SCORM_2004_3RD_EDITION",
                "location": "Home > demo_content > nested_folder"
            }
        }
    },
    "user": "john.user@organization.com",
    "timestamp": "2023-10-19T13:54:00.284256Z",
    "target_url": "https://target.system.com",
    "logging_mode": "FULL_ON_ERROR",
    "max_attempts": 1
}
```

#### Registration Launched {#registration_launched}
```
{
    "subscription_id": 2,
    "name": "demo-webhook",
    "topic": "REGISTRATION",
    "subtopic": "REGISTRATION_LAUNCHED",
    "resource": {
        "account": {
            "id": 15023,
            "name": "demo-account-name",
            "enabled": true
        },
        "content": {
            "course": {
                "id": 31099,
                "name": "demo-aicc-course-name",
                "version_id": 0,
                "learning_standard": "AICC",
                "location": "Home > demo-aiccFolder > nested-aiccFolder"
            }
        },
        "registration": {
            "account_id": 15023,
            "registration_id": "28690",
            "course_id": 31099,
            "learner_id": "john.learner@organization.com"
        }
    },
    "user": "john.learner@organization.com",
    "timestamp": "2023-10-19T13:57:37.357176Z",
    "target_url": "https://target.system.com",
    "logging_mode": "FULL_ON_ERROR",
    "max_attempts": 1
}
```

#### Registration Status Updated {#registration_status_updated}
```
{
    "subscription_id": 2,
    "name": "demo-webhook",
    "topic": "REGISTRATION",
    "subtopic": "REGISTRATION_STATUS_UPDATED",
    "resource": {
        "account": {
            "id": 15023,
            "name": "demo-account-name",
            "enabled": true
        },
        "content": {
            "course": {
                "id": 31099,
                "name": "demo-aicc-course-name",
                "version_id": 0,
                "learning_standard": "AICC",
                "location": "Home > demo-aiccFolder > nested-aiccFolder"
            }
        },
        "registration": {
            "account_id": 15023,
            "registration_id": "28690",
            "course_id": 31099,
            "learner_id": "john.learner@organization.com",
            "completion": "Completed",
            "success": "PASS",
            "score": 80,
            "duration": 24,
            "completion_dt": "2023-10-19T13:58:05.000Z"
        }
    },
    "user": "john.learner@organization.com",
    "timestamp": "2023-10-19T13:58:04.737692Z",
    "target_url": "https://target.system.com",
    "logging_mode": "FULL_ON_ERROR",
    "max_attempts": 1
}
```

{{< line_break >}}

## Webhook Statistics {#statistics}
Content Controller keeps a record of a webhook's success and failure count, as well as the webhook's last encountered error message. From the Content Controller UI, users would be able to tell if a webhook is 'in error' (the webhook has encountered a failure more recently than a success) by the Alert symbol beside the webhook name on the Webhooks List page. The webhook's last error message would also appear in the Webhook Detail panel. These alerts should clear after that webhook successfully delivers a postback message or after the webhook is edited.


When using the Automation API, you get access to a few more details. Here's an example payload from the `GET /webhooks/{webhook_id}/statistics` endpoint:
```
{
    "statistics_valid_from_dt": "2024-01-01T13:00:00.000Z",
    "success_count": 20,
    "last_success_dt": "2024-03-01T15:00:00.000Z",
    "error_count": 3,
    "last_error_dt": "2024-03-05T14:00:00.000Z",
    "last_error_message": "Request to postback URL 'https://target.system.com' failed for reason: Forbidden "
}
```

Through the API, you can view the success and failure counts for a webhooks, as well as the error message from the last failure. In the example payload above, the `last_error_dt` is more recent than the `last_success_dt`, so this webhook would be considered 'in error' and would display the alert icons in the UI.

Finally, a webhook's statistics can be reset via the API. Using the `POST /webhooks/{webhook_id}/statistics/reset` endpoint or `PUT /webhooks/{webhook_id}` with `resetStatistics=true` as a query parameter, you can clear out the success and failure records for a webhook. Doing so will update the 'valid_from_dt' value to the current timestamp.

{{< line_break >}}

## How to Use {#use}
In the UI, Webhooks can be accessed by Admin users via the Administration page. Navigate to the Integrations tab and select 'Webhooks' from the sidebar. This is the Webhooks list page, which will display all webhooks as well as some basic information about each one. A link to the User Guide is [here](https://guide.contentcontroller.com/settings/webhooks).

Webhooks can be accessed via the Automation API via a set of `/webhooks` endpoints. For more details, see the documentation for our Automation API [here](/automation-api/v1).

