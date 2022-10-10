#!/bin/bash

loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

configfile="/Users/$loggedInUser/Library/Application Support/inSync/inSync.cfg"

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


