#!/bin/sh
: '
-------------------------
| macOS LAPS Uninstall |
-------------------------
| unloads the launchDaemon macOSLAPS
| removes the following files" 
| 
------------------------------------------------------------
| Created: Richard Purves - https://github.com/franton
| Last Update by: Joshua D. Miller - josh.miller@outlook.com
| Last Updated: March 19, 2022
| Further update to become an uninstall script by PerryK
------------------------------------------------------------
'
# Path to the LaunchDaemon
LAPS_DAEMON="/Library/LaunchDaemons/edu.psu.macoslaps-check.plist"
LAPS_PATHFILE="/etc/paths.d/laps"
LAPS_BIN="/usr/local/laps/macOSLAPS"
LAPS_REPAIR="/usr/local/laps/macOSLAPS-repair"
LAPS_FOLDER="/usr/local/laps"


# If the LD exists
if [ -f "$LAPS_DAEMON" ];
then
   echo "stopping LaunchDaemon"
   # Stop the LaunchDaemon running and Disable it
   /bin/launchctl bootout system/edu.psu.macoslaps-check

   # Remove the existing file.
   /bin/rm -f "$LAPS_DAEMON"

   # Let LaunchD sort itself out.
   sleep 3
else
   echo "LaunchDaemon not found"
   exit 0
fi

if [ -f "$LAPS_PATHFILE" ];
then
   echo "deleting pathfile"
   /bin/rm -f "$LAPS_PATHFILE"
fi

if [ -f "$LAPS_BIN" ];
then
   echo "deleting main binary"
   /bin/rm -f "$LAPS_BIN"
fi

if [ -f "$LAPS_REPAIR" ];
then
   echo "deleting repair binary"
   /bin/rm -f "$LAPS_REPAIR"
fi

if [ -d "$LAPS_FOLDER" ];
then
   echo "deleting local folder"
   /bin/rmdir "$LAPS_FOLDER"
fi

exit 0