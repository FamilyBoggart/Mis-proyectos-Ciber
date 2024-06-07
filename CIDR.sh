#!/bin/bash

function network_range {
	for ip in $ipaddr
	do
		netrange=$(whois $ip | grep "NetRange\|CIDR" | tee -a CIDR.txt)
		cidr=$(whois $ip | grep "CIDR" | awk '{print $2}')
		echo -e "\nNetRange for $ip :"
		echo -e "$netrange"
	done
}

function ping_net {
	wip=$(ifconfig wlan0 | grep "inet " | awk '{print $2}')
	subnet_mask=$(ifconfig wlan0 | grep "inet" | awk '{print $4}')
	echo -e "\nTu IP es: \t\t\t$wip"
	echo -e "Tu mascara de subred es: \t$subnet_mask"
}


if [ $# -eq 0 ]
then
	echo -e "Tienes que especificar un dominio.\n"
	echo -e "Uso: "
	echo -e "\t$0 <doamin>"
	read -p  "¿Quieres trabajar con tu direccion IP? (y/n) " option
	if [ "$option" == "y" ]
	then
		ping_net
	fi
else if [ $# -eq 1 ]
then
	domain=$1
	hosts=$(host $domain | grep "has address" | cut -d" " -f4 | tee discovered_host.txt)
	ipaddr=$(host $domain | grep "has address" | cut -d" " -f4 | tr "\n" " ")
	echo -e "Options aviable"
	echo -e "\t1) Identify the corresponding network range of target domain"
	echo -e "\t*)Exit\n"
	read -p "Choose your option: " opt

	case $opt in
		"1") network_range ;;
		"*") exit 0;
	esac
	fi
fi
