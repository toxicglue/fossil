#!/bin/bash
echo "Create new repos: $1"
sudo docker container exec fossil fossil init -A admin $1
