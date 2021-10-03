#!/bin/bash

# Storyline: Extract IPs from emergingthreats.net and create a firewall ruleset

# Regex to extract the networks
# 5             134.            128.            0/      19

function badIPs_creation() {

	# Downloads the emerging-drop.suricata.rules file and puts it in the /tmp/ 
	wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules

	# Prints out the emerging-drop.suricata.rules file and organizes it in badips.txt
	egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt
}

#Check if the emerging threats file exists
eFile="/tmp/emerging-drop.suricata.rules"
#wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules

if [[ -f "${eFile}" ]]
then

	#Prompt if we should redownload this file
	echo "The file ${eFile} has already been downloaded."
	echo -n "Do you want to download it again? [y|N]"
	read re_download

	if [[ "${re_download}" == "N" || "${re_download}" == "" ]]
	then

		echo "Pushing on..."

	elif  [[ "${re_download}" == "y" ]]
	then

		echo "Downloading..."
		badIPs_creation

	# If the admin doesn't specify a y or N then error.
	else
		echo "Invalid value"
		exit 1
	fi
fi

while getopts 'icwm:' OPTION ; do

	case "$OPTION" in

		i) iptables=${OPTION}
		;;
		c) cisco=${OPTION}
		;;
		w) windows=${OPTION}
		;;
		m) mac=${OPTION}
		;;
		p) parse=${OPTION}
		;;
		*)
			echo "Invalid Value"
			exit 1
		;;
	esac
done

# Create switch for iptables
if [[ ${iptables} ]]
then
	for eachIP in $(cat badIPs.txt)
	do
		
		echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.iptables
	done
	clear
		echo "Saving to badIPS.iptables"
fi

# Create switch for cisco
if [[ ${cisco} ]] 
then
	egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.0' badIPs.txt | tee badIPS.nocisco
	for eachIP in $(cat badIPS.nocisco)
	do
		echo "deny ip host ${eachIP} any" | tee -a badIPS.cisco
	done
	rm badIPS.nocisco
	clear
		echo 'Saving to badIPS.cisco'
fi
# Create switch for windows firewall
if [[ ${windows} ]]
then
	egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.0' badIPs.txt | tee badIPS.windows
	for eachIP in $(cat badIPS.windows)
	do
		echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachIP}\" dir=in action=block remoteip=${eachIP}" | tee -a badIPS.netsh
	done
	rm badIPS.windows
	clear
	echo "Created badIPS.netsh
fi
# Create switch for mac
if [[ ${mac} ]]
then
	echo '
	scrub-anchor "com.apple/*"
	nat-anchor "com.apple/*"
	rdr-anchor "com.apple/*"
	dummynet-anchor "com.apple*"
	anchor "com.apple*"
	load anchor "com.apple" from "/etc/pf.anchors/com.apple"
	' | tee pf.conff
	for eachIP in $(cat badIPS.txt)
	do
		echo "block in from ${eachIP} to any" | tee -a pf.conf
	done
	clear
	echo "Created IP tables for firewall drop rules in file \"pf.conf\""
fi
# Parse Cisco
if [[ ${parse} ]]
then
	wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv
	awk '/domain/ {print}' /tmp/targetedthreats.csv | awk -F \" '{print $4}' | sort -u > threats.txt
	echo 'class-map match-any BAD_URLS' | tee ciscotarget.txt
	for eachIP in $(cat threats.txt)
	do
		echo "match protocol http host \"${eachIP}\"" | tee -a ciscotarget.txt
	done
	rm threats.txt
	echo "Cisco has been parsed."
fi
