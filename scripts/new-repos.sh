#!/bin/bash
# Simple script to add a new repository to Fossil

echo "Create new repos: $1"
sudo docker container exec fossil fossil init -A admin $1
