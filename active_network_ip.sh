#!/bin/bash

# Next 2 functions are used to obtain Mac and IP of the active network interface
dumpIpForInterface()
{ 
  IT=$(ifconfig "$1") 
  #if [[ "$IT" != *"status: active"* ]]; then
  #  return
  #fi 
  #if [[ "$IT" != *" broadcast "* ]]; then
  #  return
  #fi
  active_ip=$(echo "$IT" | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}')
  echo "Active IP: $active_ip"
}

Get_IP()
{ 
  # snagged from here: https://superuser.com/a/627581/38941
  DEFAULT_ROUTE=$(route -n get 0.0.0.0 2>/dev/null | awk '/interface: / {print $2}')
  #echo "I think we found interface $DEFAULT_ROUTE as the default interface currently."
  if [ -n "$DEFAULT_ROUTE" ]; then
    dumpIpForInterface "$DEFAULT_ROUTE"
  else
    for i in $(ifconfig -s | awk '{print $1}' | awk '{if(NR>1)print}')
    do 
      if [[ $i != *"vboxnet"* ]]; then
        dumpIpForInterface "$i"
      fi
    done
  fi
}

Get_IP
