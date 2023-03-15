#! /bin/bash
# Test using at command

echo "This script ran at $(date +%B%d,%T)" > skripta82.out
echo
sleep 5
echo "This is the script's end...." >>skripta82.out

