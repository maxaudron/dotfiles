#!/usr/bin/env sh

for f in $(find "$HOME/.shell/functions/" -type 'f'); do
    . "$f"
done
