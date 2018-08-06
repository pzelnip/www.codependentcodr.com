#!/bin/sh

echo "Blackening code...."

make blackenit

if [ -z "$(git status --porcelain)" ]; then
    exit 0
else
    echo "Dirty directory"
    git commit -am "BLACK-123 Automated Black out"
    # git push origin HEAD
fi
