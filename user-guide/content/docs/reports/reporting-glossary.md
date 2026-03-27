---
description: >-
  This page provides a glossary on key terms related to reporting in Content
  Controller.
---

# Reporting glossary

### General Terminology

The table below provides simple definitions of terms you may see throughout our reporting.



<table><thead><tr><th width="239">Term</th><th>Definition</th></tr></thead><tbody><tr><td><strong>accountId</strong></td><td>The ID assigned to an account by Content Controller upon creation</td></tr><tr><td><strong>accountName</strong></td><td>The name given to the Content Controller account (can be edited to be changed)</td></tr><tr><td><strong>completionDate</strong></td><td>Date stamp for when the course communicates a completion to the LMS and Content Controller</td></tr><tr><td><strong>contentID</strong></td><td>The ID assigned to a piece of content when it is imported into Content Controller</td></tr><tr><td><strong>courseName</strong></td><td>The title of the course in the <strong>Content</strong> → <strong>Courses</strong> section</td></tr><tr><td><strong>course_version</strong></td><td>The version of the course that was launched for this registration record</td></tr><tr><td><strong>firstLaunchDate</strong></td><td>the date stamp for when the course was first launched and the registration was created</td></tr><tr><td><strong>firstName</strong></td><td>Learner first name assigned by the LMS</td></tr><tr><td><strong>Language</strong></td><td>The language assigned to the course in Content Controller if provided</td></tr><tr><td><strong>lastName</strong></td><td>Learner last name assigned by the LMS</td></tr><tr><td><strong>learnerID</strong></td><td>The unique identifier for the learner that is assigned by the LMS</td></tr><tr><td><strong>Location</strong></td><td>The folder location of the course inside the <strong>Content</strong> → <strong>Courses</strong></td></tr><tr><td><strong>registrationCompletion</strong></td><td>The overall completion status of the registration (or the learner’s overall relationship with the course). This value can be set as COMPLETE, INCOMPLETE, or UNKNOWN. This is dependent on what the course communicates with the LMS and Content Controller. If it does not set COMPLETE or INCOMPLETE on any of the learner’s course launches, this value should be reflected as UNKNOWN.</td></tr><tr><td><strong>registrationDuration</strong></td><td>The amount of time spent in the course in seconds (from learner launch to learner exit) from the latest or most recent launch of the course.</td></tr><tr><td><strong>registrationId</strong></td><td>Unique identifier for the learner’s registration that is assigned at course launch. A registration is considered to be one learner’s overall relationship with one course.</td></tr><tr><td><strong>registrationSatisfaction</strong></td><td>The satisfaction value for the registration record. This is communicated by the course to the LMS and ContentController. This can reflect a value of UNKNOWN, PASS, or FAIL. If the course does not set a PASS or FAIL value on any of the learner’s course launches, the record should reflect UNKNOWN.</td></tr><tr><td><strong>registrationScore</strong></td><td>The score <em>value</em> for the registration record. The way this value is calculated is largely dependent on the learning standard of the host course. In many cases, this will reflect the last score that was achieved on the most recent launch of the course. If the course does not set a score, this will show as 0.</td></tr><tr><td><strong>Tags</strong></td><td>Any tags that are assigned to a course in <strong>Content</strong> → <strong>Courses</strong></td></tr></tbody></table>

###

### Learner History Report Terminology

The table below provides definitions of terms specific to the [learner-reports.md](learner-reports.md "mention")that you may see in that reporting.



<table><thead><tr><th width="242">Term</th><th>Definition</th></tr></thead><tbody><tr><td><strong>launchCompletion</strong></td><td>specifies the completion status for a course launch record (individual launch of a piece of content). This value can be set as COMPLETE, INCOMPLETE, or UNKNOWN. This is dependent on what the course communicates with the LMS and Content Controller. If it does not set COMPLETE or INCOMPLETE on this particular launch, this value should be reflected as UNKNOWN.</td></tr><tr><td><strong>launchDuration</strong></td><td>The time spent (from learner launch to learner exit) in seconds for any given launch of a course. This value will add up/accumulate over subsequent launches.</td></tr><tr><td><strong>launchSatisfaction</strong></td><td>The satisfaction value for a given course launch record. This is communicated by the course to the LMS and ContentController. This can reflect a value of UNKNOWN, PASS, or FAIL. If the course does not set a PASS or FAIL value, the record should reflect UNKNOWN (in dashboard style reports in the CC UI, this can also be seen as ‘In Progress’).</td></tr><tr><td><strong>launchScore</strong></td><td>The score value for a given course launch record. This is communicated by the course to the LMS and Content Controller. If the course does not set a score, this will show as 0.</td></tr></tbody></table>

###

### Limit by Content Report Terminology

The table below provides definitions of terms specific to the **Limit by Content** under [usage-reports.md](usage-reports.md "mention").



<table><thead><tr><th width="247">Term</th><th>Definition</th></tr></thead><tbody><tr><td><strong>Active</strong></td><td>If the account is active (or inactive)</td></tr><tr><td><strong>Effective Date</strong></td><td>This is the effective date of the license that is active on this piece of content. If there is a date limit set, then this date is what is used to start that count of days. For example, if you set a 90-day limit, then the limit would start counting on the effective date.</td></tr><tr><td><strong>Expiration</strong></td><td>This is the date that the duration limit is set to be reached</td></tr><tr><td><strong>Limit status</strong></td><td>This shows at what stage any assigned limit for this content is. Good, approaching or exceeded. This is only for the active license.</td></tr><tr><td><strong>License active</strong></td><td>This is whether or not you have made a license acive. You can have added content to an account but not made the license active yet.</td></tr></tbody></table>

