# OK
function dig_to_byte()
{
	local n=128
	local number=$1
	local bit

	while [ $n -gt 0 ]
	do

		if [ $number -ge $n ]
		then
			number=$(($number - $n))
			bit+="1"
		else
			bit+="0"
		fi
		n=$(($n / 2))
	done
	echo $bit
}

function byte_to_dig {

	local bin_array=$1
	local num=0
	local n=128
	local bit

	for((i=0;i<8;i++))
	do
		bit=${bin_array:$i:1}
		if [[ $bit == "1" ]]
		then
			num=$(($num + $n))
		fi
			n=$(($n / 2))
	done
	echo $num
} 

case $1 in
	"dig_to_byte") dig_to_byte $2 ;;
	"byte_to_dig") byte_to_dig $2 ;;
	"*") exit 0 
esac
