#!/bin/bash
###############################################################################
LINE=74
MARGIN=40
SPACE="                                                         "
MSG=""
LSTRING=""
COUNT=0
DEVICE="7601"
TOTAL_TMP=""
TOTAL_INFO=""
RESULT_PATH="/dev/wifi"
RESULT=$RESULT_PATH/list_ap
###############################################################################
load_drv ()
{
	local ic_device="$1"
	local interface=""
	local driver_cmd=""
	local driver_path="/sbin"
	local drv_flag="" 
    
    echo ">>>>>>load_drv"

	case ${ic_device} in
	7601)
		interface=wlan1
		driver_cmd="wifi_drv_load.usb_rt${ic_device}sta"
		if [ -e "$driver_path/$driver_cmd" ]
		then
			drv_flag=`lsmod | grep "mt7601Usta"`
			if [ -z "$drv_flag" ]; then
				"$driver_path/$driver_cmd" > /dev/null
			fi
		else
			echo "No command ${driver_cmd} found"
		fi

		;;

	*)
		echo "this device not supported."
		;;
	esac
}
###############################################################################
dev_find ()
{
echo ">>>>>>dev_find"
	local obj=""
	local str=""
	local num1=""
	local num2=""
	local result=""
	local msg_pci=""
	local msg_usb=""
	local msg_all=""
	local is_empty=""

	msg_usb=`lsusb`
	if [ -z "$msg_usb" ]
	then 
		msg_usb="0"
	fi

	if [ -e /sys/bus/pci/devices ]
	then
		msg_pci=`lspci`
		msg_pci=${msg_pci:34:29}
	fi

	if [ -z "$msg_usb" -a -z "$msg_pci" ]
	then
		echo "no device found."
		exit
	fi

	msg_all="${msg_usb}0000000${msg_pci}"
	MSG=${msg_usb/${msg_usb}/${msg_all}}

	for obj in ${DEVICE}
	do 
		result=$(echo $MSG | grep "$obj")
		if [ ! -z "$result" ];then
			str=$(echo $MSG | eval "sed 's/${obj}.*//'")
			num1=${#str}
			num2="$num1:$num2"
			LSTRING=${num1/$num1/${num2}}
		fi
	done

	if [ -z "$LSTRING" ]
	then
		echo "no supported device found."
		exit
	fi
echo "<<<<<<devfind"
	
}
###############################################################################
device_action ()
{
echo ">>>>>>dev_action"
	local i=1
	local tmp=0
	local total=1
	local msg=""
	local target=""

	dev_find #function

	msg=$(echo $LSTRING | eval "awk -F":" '{print $"$i"}'")	
	while [ ! -z $msg ]
	do
		msg=$(echo $LSTRING | eval "awk -F":" '{print $"$total"}'")	
		total=$(($total+1))
	done

	i=1
	while [ $i -lt $(($total-1)) ]
	do
		location=$(echo $LSTRING | eval "awk -F":" '{print $"$i"}'")	
		if [ "$tmp" -eq 0 ];then
			tmp="$location"
		elif [ "$tmp" -gt "$location" ];then
			tmp="$location"
		fi
		i=$(($i+1))
	done

	target=${MSG:$(($tmp-28)):32}
	target=$(echo $target | awk -F":" '{print $3}' | awk '{print $1}')

	for obj in ${DEVICE}
	do
		if [ "$target" = $obj ]; then
			load_drv "$target" 
		fi
	done
echo "<<<<<<dev_action"
}
###############################################################################
align_print ()
{
	local name=$1
	local margin=$2
	echo -ne "${name}${SPACE:0:$((${margin}-${#name}))}"
}
###############################################################################
print_line ()
{
	local count=0
	local line0="="
	local line1=""
	local line2=""
	while [ "$count" -lt "$1" ]
	do
		line0="="
		line1="$line0$line1"
		line2=${line0/$line0/${line1}}
		count=$(($count+1))
	done
	echo -e $line2
}
###############################################################################
format_out ()
{
	print_line $LINE
	align_print ESSID 133;align_print CHANNEL 13;align_print SIGNAL 10
		align_print ENCRYPT 10;align_print SECURITY 10
	echo;
	print_line $LINE
}
###############################################################################
catch_info_p ()
{
	local essid
	local singal
	local channel
	local encrypt
	local security

	ssid=$(echo $1 | sed 's/.*ESSID://' | sed 's/ Mode:.*$//')
	ssid=$(echo $ssid | sed 's/ Bit Rates:.*$//')
	ssid=$(echo $ssid | sed 's/ Protocol:.*$//')
	channel="$(echo $1 | sed 's/.*Frequency://' | awk '{print $4}')"
	channel=${channel:0:$((${#channel}-1))}
	signal=$(echo $1 | sed 's/.*Signal level=//' | awk '{print $1}')
	encrypt=$(echo $1 | sed 's/.*Encryption//' | awk -F":" '{print $2}' | \
		awk '{print $1}')
	security=$(echo $1 | grep "WPA") || $(echo $1 | grep "WPA2")
	if [ "$encrypt" = "off" ]; then
		security="NONE"
	elif [ "$encrypt" = "on" ]; then
		if [ -z "$security" ]; then
			security="WEP"
		else
			security="WPAPSK"
		fi
	fi

	align_print "$ssid" 133;align_print $channel 10;align_print $signal 12
		align_print $encrypt 9;align_print $security 10
	echo 
}
###############################################################################
catch_info_l ()
{
	local essid
	local singal
	local channel
	local encrypt
	local security

	tag="$2"
	ssid=$(echo $1 | sed 's/.*ESSID://' | sed 's/ Mode:.*$//')
	ssid=$(echo $ssid | sed 's/ Bit Rates:.*$//')
	ssid=$(echo $ssid | sed 's/ Protocol:.*$//')
	channel="$(echo $1 | sed 's/.*Frequency://' | awk '{print $4}')"
	channel=${channel:0:$((${#channel}-1))}
	signal=$(echo $1 | sed 's/.*Signal level=//' | awk '{print $1}')
	encrypt=$(echo $1 | sed 's/.*Encryption//' | awk -F":" '{print $2}' | \
		awk '{print $1}')
	security=$(echo $1 | grep "WPA") || $(echo $1 | grep "WPA2")
	if [ "$encrypt" = "off" ]; then
		security="NONE"
	elif [ "$encrypt" = "on" ]; then
		if [ -z "$security" ]; then
			security="WEP"
		else
			security="WPAPSK"
		fi
	fi

	echo  -e "$ssid $channel $signal $encrypt $security" >> $RESULT
}
###############################################################################
catch_info_s ()
{
	local essid
	local encrypt
	local security
	local match_flag

	match_flag=$3
	essid=$(echo $1 | sed 's/.*ESSID://' | sed 's/ Mode:.*$//')
	essid=$(echo $essid | sed 's/ Bit Rates:.*$//')
	essid=$(echo $essid | sed 's/ Protocol:.*$//')
#	essid=$(echo $1 | sed 's/.*ESSID://' | awk '{print $1}')
#	essid=${essid:1:$((${#essid}-2))}
	encrypt=$(echo $1 | sed 's/.*Encryption//' | awk -F":" '{print $2}' | \
		awk '{print $1}')
	security=$(echo $1 | grep "WPA") || $(echo $1 | grep "WPA2")
	if [ "$encrypt" = "off" ]; then
		security="NONE"
	elif [ "$encrypt" = "on" ]; then
		if [ -z "$security" ]; then
			security="WEP"
		else
			security="WPAPSK"
		fi
	fi

	if [ "$essid" = "\"$2\"" ];then
		match_flag=1
		if [ "$security" = "NONE" ]; then
			exit 1
		elif [ "$security" = "WEP" ]; then
			exit 2
		elif [ "$security" = "WPAPSK" ]; then
			exit 3
		fi
	fi
}
###############################################################################
device_status ()
{
	local msg0
	local msg1
	local msg2
	local device
	
	device="$1"
	msg0=`ifconfig -a`

	msg1=$(echo $msg0 | grep "$device")
	if [ ! -z "$msg1" ]; then
		msg2=$(echo $msg0 | eval sed 's/.*"$device"//' | \
			sed 's/BROADCAST.*//' | awk '{print $5}')
		if [ -z "$msg2" ]; then
			/sbin/ifconfig $device up
		fi
	else
		echo "no such interface." > $RESULT
		exit 6
	fi
}
###############################################################################
getmsg ()
{
echo ">>>>>>getmsg"
	local i
	local tmp
	local msg
	local flag
	local cell
	local time
	local ap_list
	local match_flag
	
	if [ "$1" = "-l" ]; then
		rm -f $RESULT
	fi
	i=1
	time=1
	match_flag="$4"
	device_status "$2"  
	if [ "$1" = "-p" ]; then
		format_out
	fi
	
	while [ -z "$tmp" ]
	do
		ap_list=`iwlist $2 scan`
		tmp=$(echo "$ap_list" | grep completed)
		if [ ! -z "$tmp" ]; then
			break
		fi
		sleep 1s
		if [ $time -le 2 ]; then
			time=$(($time+1))
		else
			echo "no ap found." > $RESULT
			return 1
		fi
	done
	
	ap_list=`iwlist $2 scan`
	msg=$(echo ${ap_list} | sed 's/^.* completed : //')
	flag=$(echo ${msg} | grep "Cell ")
	while [ ! -z "$flag" ]
	do
		if [ $i -lt 10 ]; then
			cell="$(echo ${msg} | eval "sed 's/.*Cell 0$i//'" | \
				eval "sed 's/Cell 0$(($i+1)).*$//'")"
		else
			cell="$(echo ${msg} | eval "sed 's/.*Cell $i//'" | \
				eval "sed 's/Cell $(($i+1)).*$//'")"
		fi
		i=$(($i+1))
		if [ $i -lt 10 ]; then
			flag=$(echo ${msg} | grep "Cell 0$i")
		else
			flag=$(echo ${msg} | grep "Cell $i")
		fi
		if [ "$1" = "-p" ]; then
			catch_info_p "$cell"
		elif [ "$1" = "-l" ]; then
			catch_info_l "$cell"
		elif [ "$1" = "-s" ]; then
			catch_info_s "$cell" "$3" "$match_flag"
		fi
	done

	if [ "$1" = "-p" ]; then
		echo 
		print_line $LINE
	fi

	return 0
}

check_link_status ()
{
	local msg
	local state
	local interface 
	
	interface=$1
	msg=`wpa_cli -i${interface} status`
	if [ "$msg" ]
	then
		state=$(echo "$msg" | grep "wpa_state" | awk -F"=" '{print $2}')
	fi

	if [ "$state" != "COMPLETED" ]
	then
		exit 8
	fi
}

disconnect ()
{
	local msg=""
	local flag=0
	local state=""
	local time=15
	local interface=""

	interface="$1"
	echo -ne "disconnect "	
	while [ "$flag" -eq 0 ]
	do
		wpa_cli -i${interface} disconnect > /dev/null

		msg=`wpa_cli -i${interface} status`
		if [ "$msg" ]
		then
			state=$(echo "$msg" | grep "wpa_state" | awk -F"=" '{print $2}')
		fi
		[ "$state" != "COMPLETED" ] && flag=1

		if [ "$time" -eq 0 ]
		then
			break
		fi

		time=$(($time-1))
		echo -ne "."
	done
		
	echo -ne " - "
	echo "$state"
}

reconnect ()
{
	local msg=""
	local state=""
	local time=15
	local interface=""
	
	interface="$1"
	echo -ne "reconnect "
	while [ "$state" != "COMPLETED" ]
	do
		wpa_cli -i${interface} reassociate > /dev/null	
		sleep 1s

		msg=`wpa_cli -i${interface} status`
		if [ "$msg" ]
		then
			state=$(echo "$msg" | grep "wpa_state" | awk -F"=" '{print $2}')
		fi

		if [ "$time" -eq 0 ]
		then
			break
		fi

		time=$(($time-1))
		echo -ne "."
	done
	
	echo -ne " - "
	echo "$state"
}

###############################################################################
do_help ()
{
	SELF=`basename $0`
	echo "Usage:"
	echo "	./$SELF -p interface"
	echo "	./$SELF -s interface ssid"
	echo "		 -p        - print ap table"
	echo "		 -s        - get security type, such as NONE, WEP, WPAPSK"
	echo "		 interface - network interface, such as wlan1, ra0"
	echo "		 ssid      - ap's identification."
	echo "Example:"
	echo "	./$SELF -p wlan1"
	echo "	./$SELF -s wlan1 dlink"
	exit 0
}

echo ">>>>>>main"

if [ $# != 2 -a $# != 3 ]; then
	do_help
fi

if [ ! -d "$RESULT_PATH" ];then
	mkdir $RESULT_PATH
fi

device_action
if [ $# = 2 ]; then
	if [ "$1" = "-p" -o "$1" = "-l" ]; then
		if getmsg $1 $2; then
			exit 7
		fi
	elif [ "$1" = "-c" ]; then
		check_link_status $2
	elif [ "$1" = "-d" ];then
		disconnect $2
	elif [ "$1" = "-r" ];then
		reconnect $2
	else
		do_help
	fi
elif [ $# = 3 ];then
	if [ "$1" = "-s" ]; then
		match_flag=0
		getmsg $1 $2 "$3" $match_flag
		if [ $match_flag -eq 0 ]; then
			exit 4
		fi
	else
		do_help
	fi
fi

