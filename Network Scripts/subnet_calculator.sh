#!/bin/bash

function cidr2mask {

	local full_octet=$(( $1 / 8 ))
	local partial_octet=$(( $1 % 8 ))

	for((i=0;i<4;i++))
	do
		if [ $i -lt $full_octet ]
		then
			ip_addr+="255."
		elif [ $i -eq $full_octet ]
		then
			local result=$((256 - 2**(8-$partial_octet)))
			ip_addr+="$result"
		else
			ip_addr+="0"
		fi
		if [ $i -lt 3 ]
		then 
			ip_addr+="."
		fi
	done

	ip_addr=$(echo $ip_addr | tr -s ".." ".")
	echo $ip_addr
}

function main_addr {

	local subnet
	local ip

	if [ $# -eq 1 ]
	then
		ip=$(echo $1 | cut -d"/" -f1)
		subnet=$(echo $1 | cut -d"/" -f2)
		subnet=$(cidr2mask $subnet)
	elif [ $# -eq 2 ]
	then
		ip=$1
		subnet=$2
	fi
	#READ IP_ADDRESS _FUNCTION
	echo -e "IP Address:\t$ip"
	echo -e "Subnet mask:\t$subnet"
}
if [ $# -eq 1 ]
then
	main_addr $1
elif [ $# -eq 2 ]
then
	main_addr $1 $2
else
	echo -e "\nThe correct usage is: \n\t./subnet_calculator.sh <CIDR_number>"
	echo -e "\nA CIDR number must be between 0 - 32"
fi
