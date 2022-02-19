#!/bin/bash
# --------------------------------------------------
# Simple script to add a existing fossil repos
# to the fossil docker volume 
# Usage: add-existing-repos.sh my_old_fossil.fossil
# --------------------------------------------------
echo "--------------------------------"
echo "Add repos:$1 to fossil"

VOLUME="$(docker volume inspect --format '{{ .Mountpoint }}' fossil_fossil-volume)"

echo "cp $1 $VOLUME/$1"

cp $1 $VOLUME/$1

echo "--------------------------------"
echo 'Finished !'
echo "--------------------------------"