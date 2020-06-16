#!/bin/sh
BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [[ "$BRANCH" != "mainline" ]]; then
    echo "Not on mainline, currently on $BRANCH"
    exit 1
fi

if [ -z "$(git status --porcelain)" ]; then
    exit 0
else
    echo "Dirty directory"
    git status
    exit 1
fi
