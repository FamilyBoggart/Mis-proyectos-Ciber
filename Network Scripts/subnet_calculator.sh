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

function byte_recon {

	local net_part=$((8-$2))
	local binary=$(./../Utils/data_conversor.sh dig_to_byte $1)
	local bin_gateway=${binary:0:$net_part}
	local bin_broadcast=${binary:0:$net_part}
	local counter=$net_part

	while (($counter <= 8))
	do
		bin_gateway+="0"
		bin_broadcast+="1"
		((counter++))
	done	

	gateway+=$(./../Utils/data_conversor.sh byte_to_dig $bin_gateway)
	broadcast+=$(./../Utils/data_conversor.sh byte_to_dig $bin_broadcast)	
}

function ipreader {

	local byte
	gateway=""
	broadcast=""

	for((i=1;i<=4;i++))
	do
		byte=$(echo $subnet | cut -d"." -f$i)
		if [ $byte -ne 255 ]
		then
			local bit=$((255- $byte))
			local count=0
			local octet
			if [ $bit -ne 0 ]
			then
				while (( $bit > 0))
				do
					bit=$(($bit / 2))
					((count++))
				done
			fi
			octet=$(echo $ip | cut -d"." -f$i)
			byte_recon $octet $count
		else
			gateway+=$(echo $ip | cut -d"." -f$i)
			broadcast+=$(echo $ip | cut -d"." -f$i)
					
		fi
		if [ $i -ne 4 ]
		then 
			gateway+="."
			broadcast+="."
		fi			
	done

	echo -e "IP Address:\t\t$ip"
	echo -e "Subnet mask:\t\t$subnet"
	echo -e "Default gateway:\t$gateway"
	echo -e "Broadcast address:\t$broadcast"
}

function main_addr {

	subnet=""
	ip=""

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
	ipreader $ip $subnet
}

if [ $# -eq 1 ]
then
	main_addr $1
elif [ $# -eq 2 ]
then
	main_addr $1 $2
else
	echo -e "\nThe correct usage is: \n"
	echo -e "\tbash subnet_calculator.sh <IPv4> <SUBNET MASK>"
	echo -e "\tbash subnet_calculator.sh <IP/CIDR>"
fi
