#!/bin/bash

loggedinuser=$(stat -f %Su /dev/console)

configfile="/Users/$loggedinuser/Library/Application Support/inSync/inSync.cfg"

if [[ -f "$configfile" ]]; then
   wruser=$(grep WRUSER "$configfile" | awk '{print $NF}' | awk -F"'" '{print $2}')
   if [[ -z "$wruser" ]]; then
      echo "<result>No User found in InSync Config</result>"
   else
      echo "<result>$wruser</result>"
   fi
else
   echo "<result>No InSync Config</result>"
fi


