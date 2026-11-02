---
title: "Reporting Glossary"
type: docs
menu:
    main:
        name: Reporting Glossary
        identifier: reporting-glossary
        parent: reports
        weight: 50
description: >-
  This page provides a glossary on key terms related to reporting in Content
  Controller.
---

# Reporting glossary

## General Terminology

The table below provides simple definitions of terms you may see throughout our reporting.

| Term | Definition |
| --- | --- |
| **accountId** | The ID assigned to an account by Content Controller upon creation |
| **accountName** | The name given to the Content Controller account (can be edited to be changed) |
| **completionDate** | Date stamp for when the course communicates a completion to the LMS and Content Controller |
| **contentID** | The ID assigned to a piece of content when it is imported into Content Controller |
| **courseName** | The title of the course in the **Content** → **Courses** section |
| **course_version** | The version of the course that was launched for this registration record |
| **firstLaunchDate** | the date stamp for when the course was first launched and the registration was created |
| **firstName** | Learner first name assigned by the LMS |
| **Language** | The language assigned to the course in Content Controller if provided |
| **lastName** | Learner last name assigned by the LMS |
| **learnerID** | The unique identifier for the learner that is assigned by the LMS |
| **Location** | The folder location of the course inside the **Content** → **Courses** |
| **registrationCompletion** | The overall completion status of the registration (or the learner’s overall relationship with the course). This value can be set as COMPLETE, INCOMPLETE, or UNKNOWN. This is dependent on what the course communicates with the LMS and Content Controller. If it does not set COMPLETE or INCOMPLETE on any of the learner’s course launches, this value should be reflected as UNKNOWN. |
| **registrationDuration** | The amount of time spent in the course in seconds (from learner launch to learner exit) from the latest or most recent launch of the course. |
| **registrationId** | Unique identifier for the learner’s registration that is assigned at course launch. A registration is considered to be one learner’s overall relationship with one course. |
| **registrationSatisfaction** | The satisfaction value for the registration record. This is communicated by the course to the LMS and ContentController. This can reflect a value of UNKNOWN, PASS, or FAIL. If the course does not set a PASS or FAIL value on any of the learner’s course launches, the record should reflect UNKNOWN. |
| **registrationScore** | The score *value* for the registration record. The way this value is calculated is largely dependent on the learning standard of the host course. In many cases, this will reflect the last score that was achieved on the most recent launch of the course. If the course does not set a score, this will show as 0. |
| **Tags** | Any tags that are assigned to a course in **Content** → **Courses** |

## Learner History Report Terminology

The table below provides definitions of terms specific to the [learner-reports](learner-reports.md "mention") that you may see in that reporting.

| Term | Definition |
| --- | --- |
| **launchCompletion** | specifies the completion status for a course launch record (individual launch of a piece of content). This value can be set as COMPLETE, INCOMPLETE, or UNKNOWN. This is dependent on what the course communicates with the LMS and Content Controller. If it does not set COMPLETE or INCOMPLETE on this particular launch, this value should be reflected as UNKNOWN. |
| **launchDuration** | The time spent (from learner launch to learner exit) in seconds for any given launch of a course. This value will add up/accumulate over subsequent launches. |
| **launchSatisfaction** | The satisfaction value for a given course launch record. This is communicated by the course to the LMS and ContentController. This can reflect a value of UNKNOWN, PASS, or FAIL. If the course does not set a PASS or FAIL value, the record should reflect UNKNOWN (in dashboard style reports in the CC UI, this can also be seen as ‘In Progress’). |
| **launchScore** | The score value for a given course launch record. This is communicated by the course to the LMS and Content Controller. If the course does not set a score, this will show as 0. |

## Limit by Content Report Terminology

The table below provides definitions of terms specific to the **Limit by Content** under [usage-reports](usage-reports.md "mention").

| Term | Definition |
| --- | --- |
| **Active** | If the account is active (or inactive) |
| **Effective Date** | This is the effective date of the license that is active on this piece of content. If there is a date limit set, then this date is what is used to start that count of days. For example, if you set a 90-day limit, then the limit would start counting on the effective date. |
| **Expiration** | This is the date that the duration limit is set to be reached |
| **Limit status** | This shows at what stage any assigned limit for this content is. Good, approaching or exceeded. This is only for the active license. |
| **License active** | This is whether or not you have made a license acive. You can have added content to an account but not made the license active yet. |
