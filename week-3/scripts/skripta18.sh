#!/bin/bash
# Changing the IFS value

IFS.OLD=$'\n'

for entry in $(cat /etc/passwd)
do
    echo "Values in $entry -"
    IFS=:
    for value in $entry
    do
        echo "  $value"
    done
done