#!/bin/bash

df -h | egrep '^s3fs.*%\s(.*)' | awk {'print $6'}

