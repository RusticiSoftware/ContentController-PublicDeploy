---
title: "Learner Counts"
description: Exploring what learner counts are and how to find them
type: docs
menu:
  main:
    name: "Learner Counts"
    identifier: learner-counts
    parent: getting-started
    weight: 80
---

# Learner counts

## What are learner counts?

Learners are counted by including any unique User ID (or Learner) collected via any Service that launches a course from Content Controller, regardless of the number of visits or courses launched. This number will be recorded in a database table within Content Controller.

## How to view your counts

There are three ways to find and view your counts, and all can be accessed in the same location.

### Count total

1. Click on the **Gear icon** in the upper right to expand the menu
2. Select **About**
3. Click on the **Count Learners** button
4. Select a **date range** by clicking on the date range box
5. Then click **Load**

{{< img src="images/learner-count.png" alt="Learner count" >}}

### Detailed view

To get a more detailed view, including accounts, follow the same steps above and select the ‘**Include** **details**’ checkbox.

{{< img src="images/select-detailed-learner-count.png" alt="Select include details" >}}

after selecting your date range click **Load** as normal to see your detailed view.

{{< img src="images/detailed-learner-count.png" alt="Detailed learner count" >}}

### CSV Export

You can also export your learner counts. After checking the "**Include** **details**" checkbox, a new button labeled "**CSV**" will appear. Clicking this button will download an export for the selected date range.

{{< img src="images/csv-learner-count-export.png" alt="Export learner count CSV" >}}

{{< hint danger >}}
It is important to know that if you attempt to compare these counts with reports within Content Controller, there _may_ be instances where they do not match. For example, deleting an account will remove all associated data from the reports, which could cause discrepancies between the counts and the reports. This behavior is expected.
{{< /hint >}}
