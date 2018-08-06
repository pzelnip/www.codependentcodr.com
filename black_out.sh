#!/bin/sh

echo "Blackening code...."

docker run -it --rm -v `pwd`:/build codependentcodr:latest black .

if [ -z "$(git status --porcelain)" ]; then
    exit 0
else
    echo "Dirty directory"
    git commit -am "BLACK-123 Automated Black out"
    git push origin HEAD
fi
