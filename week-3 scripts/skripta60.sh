#! /bin/bash
# Redirecting all output to different locations

exec 2>testerror
echo "This is a start from a script"
echo "Now redirecting all output to another locaation"
exec 1>testout
echo "This output should go to the testout file"
echo "but this should go to the testerror file" >&2



