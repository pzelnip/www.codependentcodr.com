#!/bin/sh
set -e

AWS_SECRET=$(aws --profile codependentcodr configure get aws_secret_access_key)
AWS_KEY=$(aws --profile codependentcodr configure get aws_access_key_id)

docker build -t sitelookmonitor -f Dockerfile .
docker run -e AWS_ACCESS_KEY_ID=$AWS_KEY -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET --rm -v `pwd`/sitecapt:/build sitelookmonitor:latest
