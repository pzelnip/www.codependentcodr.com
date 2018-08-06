#!/bin/sh

set -e

echo "Blackening code for $2...."

docker run -it --rm -v `pwd`:/build codependentcodr:latest black .

if [ -z "$(git status --porcelain)" ]; then
    exit 0
else
    echo "Dirty directory"
    git --no-pager log -n 20
    echo "Checking out $2"
    git checkout $2
    git branch
    git commit -am "BLACK-123 Automated Black out"
    echo "Committed now what"
    git --no-pager log -n 20
    git remote -v
    git push https://$1@github.com/pzelnip/www.codependentcodr.com $2
    echo "Blackened changes, aborting build"
    exit 1

fi
