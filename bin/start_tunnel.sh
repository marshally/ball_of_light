#!/bin/sh
pid=`ps -axo pid,command,args | grep -i "2114" | grep -v grep | awk '{ print $1 }'`

if [ "`ping -c 1 4.2.2.1`" ]; then #if ping exits nonzero...
  if [ ! "$pid" ]; then
    ssh -fN -R 2114:localhost:22 marshally@yountlabs.com
  fi
else
  if [ "$pid" ]; then
    kill -9 $pid
  fi
fi

# NOTE: get back in with `ssh -p 2114 -l macmini localhost`
