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

if [ $# -eq 1 ] && [ $1 -lt 33 ] && [ $1 -ge 0 ]
then
	cidr2mask $1
else
	echo -e "\nThe correct usage is: \n\t./subnet_calculator.sh <CIDR_number>"
	echo -e "\nA CIDR number must be between 0 - 32"
fi
