#!/bin/sh

aws s3 sync ./output s3://www.codependentcodr.com --delete
