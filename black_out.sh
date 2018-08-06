#!/bin/sh

set -e

echo "Blackening code for $TRAVIS_BRANCH...."

docker run -it --rm -v `pwd`:/build codependentcodr:latest black .

if [ -z "$(git status --porcelain)" ]; then
    exit 0
else
    echo "Dirty directory"
    git commit -am "BLACK-123 Automated Black out"
    git push https://${GH_TOKEN}@github.com/pzelnip/www.codependentcodr.com $TRAVIS_BRANCH
    echo "Blackened changes, aborting build"
    exit 1
fi
