#!/bin/sh

set -e

if [ $# -le 1 ]
  then
    echo "No arguments supplied, need to supply github token & branch to build"
    exit 1
fi

echo "Blackening code for $2...."

# Run black over the code
docker run -it --rm -v `pwd`:/build codependentcodr:latest black .

# if no changes, then exit cleanly
if [ -z "$(git status --porcelain)" ]; then
    exit 0
else
    # else lets commit the blackening...

    echo "Dirty directory"

    # Have to check out the branch because Travis is dumb, on
    # a branch build it checks out a detached HEAD instead of
    # the branch itself
    echo "Checking out $2"
    git checkout $2

    # commit the changes
    git commit -am "BLACK-123 Automated Black out"

    # push back to Github & abort the build since a new build will
    # get triggered by the push
    git push https://$1@github.com/pzelnip/www.codependentcodr.com $2
    echo "Blackened changes, aborting build"
    exit 1
fi
