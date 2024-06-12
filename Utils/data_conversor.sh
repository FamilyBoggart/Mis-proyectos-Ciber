# OK
dig_to_byte()
{
	local n=128
	local number=$1
	local bit=""

	while [ $n -gt 0 ]
	do
		if [ $number -ge $n ]
		then
			number=$(($number - $n))
			bit+="1"
		else
			bit+="0"
		fi
		((n/=2))
	done
	echo $bit
}

