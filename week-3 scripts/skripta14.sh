#!/bin/bash
# Using the until command

var1=100

until echo $var1
    [ $var1 -eq 0 ]

do
    echo inside the loop: $var1
    var1=$[ $var1 - 25 ]
done
