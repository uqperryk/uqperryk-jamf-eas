#!/bin/bash

loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

configfile="/Users/$loggedInUser/Library/Application Support/inSync/inSync.cfg"

if [[ -f "$configfile" ]]; then
   lastconnect=$(grep -w LAST_CONNECT "$configfile" | awk '{print $NF}' | awk -F"." '{print $1}')
   if [[ -z "$lastconnect" ]]; then
      echo "<result>No last connect time in InSync Config</result>"
   else
      timeinenglish=$(date -r "$lastconnect")
      echo "<result>$timeinenglish</result>"
   fi
else
   echo "<result>No InSync Config</result>"
fi
