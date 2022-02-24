#!/bin/sh

if [ ! -e “/data/fossil.fossil” ]
then
/usr/local/bin/fossil init -A $USERNAME /data/fossil.fossil
fi

if [ ! -z $PASSWORD ]
then
/usr/local/bin/fossil user password $USERNAME $PASSWORD -R /data/fossil.fossil
fi

unset $USERNAME
unset $PASSWORD

if [ -w “/data/fossil.fossil” ]
then
/usr/local/bin/fossil server /data/fossil.fossil --scgi --port 9000
fi
