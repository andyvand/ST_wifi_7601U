#!/bin/sh
##################housir bash 还是其他
###############################################################################
MSG=""
LSTRING=""
COUNT=0
DEVICE="7601 9271 3070 5370 8178 002b" #housir MK7601U
###############################################################################
select_ap ()
{
	local cmd=""
	local ic_device="$1"
	local interface=""
	local path="/usr/sbin" #maybe need to modify
	local args="${2} ${3} ${4}"

	case ${ic_device} in
	7601)
		interface=wlan0
		cmd="ap_rt7601_start.sh"
		if [ -e "$path/$cmd" ]
		then
			"$path/$cmd" $interface $args
		else
			echo "No command ${cmd} found"
		fi
		;;

	9271)
		interface=wlan0
		cmd="ap_ar9271_start.sh"
		if [ -e "$path/$cmd" ]
		then
			"$path/$cmd" $interface $args
		else
			echo "No command ${cmd} found"
		fi
		;;
	3070)
		interface=ra0
		cmd="ap_rt3070_start.sh"
		if [ -e "$path/$cmd" ]
		then
			"$path/$cmd" $interface $args
		else
			echo "No command ${cmd} found"
		fi
		;;
	5370)
		interface=ra0
		cmd="ap_rt5370_start.sh"
		if [ -e "$path/$cmd" ]
		then
			"$path/$cmd" $interface $args
		else	
			echo "No command ${cmd} found"
		fi
		;;
	8178)
		interface=wlan0
		cmd="ap_rtl8188cu_start.sh" 
		if [ -e "$path/$cmd" ]
		then
			"$path/$cmd" $interface $args
		else
			echo "No command ${cmd} found"
		fi
		;;
	002b)
		interface=wlan0
		cmd="ap_ar9285_start.sh"
		if [ -e "$path/$cmd" ]
		then
			"$path/$cmd" $interface $args
		else
			echo "No command ${cmd} found"
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

	if [ -e /sys/bus/pci/devices ] #have no 2条线路
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
	MSG=${msg_usb/${msg_usb}/${msg_all}} #housir:msg_usb has too long

	for obj in ${DEVICE} #处理lsusb的结果
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
	
}
###############################################################################
ap_action ()
{
	local i=1
	local flag=""
	local target=""
	local ssid="$1"
	local security="$2"
	local password="$3"
	local tmp=0
	local total=1

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
		if [ "$target" = $obj ];then
			select_ap $target $ssid $security $password
		fi
	done
}
###############################################################################
do_help ()
{
	self=`basename $0` #cut name
	echo "Usage :"
	echo "	./$self ssid security password"
	echo "		ssid	  -  ap's indentificaton"
	echo "		security  -  such as NONE, WEP, WPAPSK"
	echo "		password  -  password for security"
	echo "Example:"
	echo "	./$self st WPAPSK a012345678"
	exit
}
###################################################################
####                    main
###################################################################
if [ $# != 2 -a $# != 3 ];then
	do_help
else
	ssid=$1
	security=$2
	password=$3
	ap_action "$ssid" "$security" "$password"
fi
