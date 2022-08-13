#!/bin/sh
# Extension Attribute to detect version of macOSLAPS installed
macoslaps=$( /usr/local/laps/macOSLAPS -version | awk '{print $1}')
if [ -e "/usr/local/laps/macOSLAPS" ]; then
	echo "<result>$macoslaps</result>"
else
	echo "<result>Not installed</result>"
fi

