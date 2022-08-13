#!/bin/bash

if [[ ! $4 ]]; then
   echo "Missing first password, need to exit immediately"
   exit 1
else
   firstpassword=$4
fi

/usr/local/laps/macOSLAPS -firstPass $4

