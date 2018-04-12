#!/bin/sh

if [ -z "$(git status --porcelain)" ]; then
    exit 0
else
    echo "Dirty directory"
    git status
    exit 1
fi
