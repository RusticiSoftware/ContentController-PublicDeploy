---
title: "The Bulk Import Tool"
type: docs
menu:
    main:
        name: Import Tool
        identifier: import_tool
        parent: features
        weight: 5
---

# The Bulk Import Tool

## What Is The Bulk Import Tool

The Bulk Import Tool is a simple command-line application. You configure it, point it at a directory, and it will go through that directory, importing all of the courses it can find into your CC installation.

Unlike the main application, we don't persist the versions of this tool in S3. Instead, once you've made your changes, just grab the new version of out the build directory (`~/cc/ContentController/service/contentcontroller-import/build/distributions`). We include both Unix and Windows versions of the tool in the same zip.

## Common Issues

The most common customer issue happens when trying to import courses that are too large, and the import tool runs out of heap space.

This is a pretty easy fix. Just perform the following steps:

For the Windows version of the tool:
1. Open file `bin/contentcontroller-import.bat`
2. Find the line `set DEFAULT_JVM_OPTS=` (should be around line 17).
3. Update that line so it says `set DEFAULT_JVM_OPTS=-Xmx1g`*
4. Save the file and rerun the tool.

For the Unix version:
1. Open file `bin/contentcontroller-import`
2. Find the line `DEFAULT_JVM_OPTS=` (should be around line 31).
3. Update that line so it says `DEFAULT_JVM_OPTS=-Xmx1g`*
4. Save the file and rerun the tool.

This is setting the maximum heap size of the application to 1 GB. To increase this value, replace the `1g` with something else. `500m` would be 500 MB, `2g` would be 2 GB, etc. Be careful here; if you're running a 32-bit version of Java, then you won't be able to go over ~1.5 GB of heap space.

If you are still having trouble after increasing the heap size, then you can limit the tool's concurrency. Usually, the tool will have multiple threads going at once, since we spend so much time waiting for the server to respond to the import requests. If we limit this concurrency, we can lower the memory requirements of the tool. To do this, open the `contentcontroller-import.yaml` config file and change the value of the `threads` setting from `4` to `1`.