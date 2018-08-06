#!/bin/sh

set -e

echo "Blackening code for $2...."

docker run -it --rm -v `pwd`:/build codependentcodr:latest black .

if [ -z "$(git status --porcelain)" ]; then
    exit 0
else
    echo "Dirty directory"
    git branch
    git commit -am "BLACK-123 Automated Black out"
    git push https://$1@github.com/pzelnip/www.codependentcodr.com $2
    echo "Blackened changes, aborting build"
    exit 1
fi
