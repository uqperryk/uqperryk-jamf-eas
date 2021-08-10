#!/bin/bash
#  Author  : Zan Bassi
#  Email   : zan@zeroonelabs.com
# # # # # #
# Build array of network interface hardware IDs
NICHIDs=( $(echo -e "open\nlist\nquit" | scutil | grep -E "Setup.*Service/[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}$" | awk -F"/" '{print $NF}') )
activeNICarray=()
activeNICcount=""
# Gets the device ID for Wi-Fi (e.g. "en0")
wifiNICid="$(echo -e "open\nlist\nquit" | scutil | grep -E "Setup.*AirPort" | awk -F"/" '{print $4}')"
wifipower="$(networksetup -getairportpower "${wifiNICid}" | awk '{ print $NF }')"
#
_buildNICarray () {
# Get the service name of each of the NIC HIDs
for NICHID in "${NICHIDs[@]}";do
# Set this to NULL.
NICip=""
# This prints out the device ID of the NIC (e.g. "en0" or "fw1").
NICdevice="$(echo -e "open\nshow Setup:/Network/Service/${NICHID}/Interface\nd.show\nquit" | scutil | grep DeviceName | awk -F " : " '{print $2}')"
# This gets the name of the network service (e.g. "Display Ethernet 2").
NICname="$(echo -e "open\nget Setup:/Network/Service/${NICHID}\nd.show\nquit" | scutil | grep UserDefinedName | awk -F " : " '{print $2}')"
# This captures the method of connection. E.g. "DHCP" or "PPPoE".
NICtype="$(echo -e "open\nshow Setup:/Network/Service/${NICHID}/IPv4\nd.show\nquit" | scutil | grep ConfigMethod | awk -F " : " '{print $2}')"
# Does the service have an IP?
if [[ ! "$(networksetup -getinfo "${NICname}" | grep -v IPv6 | grep "IP address" | awk -F": " '{print $2}')" = "" ]];then
NICip=":$(networksetup -getinfo "${NICname}" | grep -v IPv6 | grep "IP address" | awk -F": " '{print $2}')"
fi
# As you see above I set NICip to NULL to gauge which service has an IP.
# Now wer're going to store each value as a colon-separated value within an array.
# This way we can stat the array and build keys within each indice.
masterNICarray+=( "${NICdevice}:\"${NICname}\"${NICip}:${NICtype}" )
done
}
_buildActiveNICarray () {
# Gotta reset values when this function is called again, otherwise we will
# be flooding the array with additional indicies.
activeNICarray=()
activeNICcount=""
for NICinfo in "${masterNICarray[@]}";do
# If the indicie fits the format of a IPv4 address:
if [[ $(echo $NICinfo | awk -F":" '$3 ~ /[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}'/) ]];then
# Add it to the array.
activeNICarray+=( "$(echo $NICinfo | awk -F":" '{print $1":"$2":"$3":"$4}')" )
fi
done
activeNICcount="${#activeNICarray[@]}"
}
_buildNICarray
_buildActiveNICarray
_printVars () {
echo -n "<result>"
echo -n ${#activeNICarray[@]}
for activeNIC in "${activeNICarray[@]}";do
echo -n "(${activeNIC})"
done
echo "</result>"
exit
}
_printVars
exit

