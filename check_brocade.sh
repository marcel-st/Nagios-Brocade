#!/bin/bash

export SSHPASS=$4
PORT=$2
HOST=$1
USER=$3
TMPFILE=`mktemp -p /tmp`

# verify sanity

if [[ -z $1 || -z $2 || -z $3 || -z $4 ]] ;
then
echo "usage $0 hostname portnumber username password"
exit
else
echo -n
fi

# Gather info

sshpass -e ssh -o StrictHostKeyChecking=no $USER@$HOST "portshow 0/$PORT" > $TMPFILE
STATE=`cat $TMPFILE |grep portState|cut -f 2 -d ":"`

# Report state to Nagios
if [[ $STATE == *Online* ]]
then
echo "OK - PortState for port 0/$PORT is online"
rm -f $TMPFILE
exit 0
fi

if [[ $STATE == *Disabled* ]]
then
echo "OK - PortState for port 0/$PORT is disabled"
rm -f $TMPFILE
exit 0
fi

echo "CRITICAL - PortState for port 0/$PORT is critical"
rm -f $TMPFILE
exit 2
