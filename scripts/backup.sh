#!/bin/bash
# ---------------------------------------------
# Simple script to backup a Fossil repository
# Usage: backup.sh fossil.fossil /home/backup
# ---------------------------------------------
echo "Backup repos: $1 --> $2/$1"
docker container exec fossil fossil backup --overwrite -R $1 /data/backup

VOLUME="$(docker volume inspect --format '{{ .Mountpoint }}' fossil_fossil-volume)"

echo "cp $VOLUME/$1 $2/$1"

cp $VOLUME/$1 $2/$1

echo "--------------------------------"
echo 'Finished !'
echo "--------------------------------"
