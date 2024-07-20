#!/bin/bash

BANNER="	   (                   )   )                       )
	 ( )\      (        ( /(( /(    (  (            ( /(
	 )((_)  (  )(   (   )(_))\())  ))\ )(   (    (  )\())
	((_)_   )\(()\  )\ |(_)((_)\  /((_|()\  )\   )\(_))/
	 | _ ) ((_)((_)_(_/(_  ) |(_)(_))  ((_)((_) ((_) |_
	 | _ \/ _ \ '_| ' \)) /| '_ \/ -_)| '_/ _ \/ _ \  _|
	 |___/\___/_| |_||_/___|_.__/\___||_| \___/\___/\__|
"

ARCHITECTURE=$(uname -a)

PHYSICAL_CPU_NB=$(lscpu | grep "CPU(s)" | awk '{print $2}' | head -n 1)

VIRTUAL_CPU_NB=$(nproc)

RAM_USED=$(free -m | grep Mem | awk '{print $3}')
RAM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
RAM_PERCENT=$(free -m | grep Mem | awk '{printf("%.2f", $3/$2 * 100)}')
RAM_USAGE="$RAM_USED/${RAM_TOTAL}MB ($RAM_PERCENT%)"

DISK_USED=$(df -Bm | grep "^/dev/" | grep -v "/boot$" | awk '{USED += $3} END {print USED}')
DISK_TOTAL=$(df -Bg | grep "^/dev/" | grep -v "/boot$" | awk '{FREE += $2} END {print FREE}')
DISK_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($DISK_USED / ($DISK_TOTAL * 1024)) * 100}")
DISK_USAGE="${DISK_USED}MB/${DISK_TOTAL}GB ($DISK_PERCENT%)"

CPU_LOAD="$(top -bn1 | grep "%Cpu(s)" | cut -c 11- | awk '{printf("%.1f", $1 + $3)}')%"

LAST_BOOT=$(who -b | awk '{printf("%s %s", $3, $4)}')

LVM_USE=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo "no"; else echo "yes"; fi)

TCP_CONNECTIONS=$(cat /proc/net/sockstat | grep "TCP:" | awk '{print $3}')

CONNECTED_USERS=$(who | wc -l)

IP_ADDRESS=$(hostname -I | awk '{print $1}')
MAC_ADDRESS=$(ip link | grep "ether" | awk '{print $2}')
NETWORK="IP: ${IP_ADDRESS} | MAC: ${MAC_ADDRESS}"

SUDO_COMMANDS=$(cat /var/log/sudo/sudo.log | grep "COMMAND" | wc -l)

wall -n "
$BANNER
				$(whoami)@$(hostname)
	#Architecture:		$ARCHITECTURE
	#Physical CPU:		$PHYSICAL_CPU_NB
	#Virtual CPU:		$VIRTUAL_CPU_NB
	#Memory Usage:		$RAM_USAGE
	#Disk Usage:		$DISK_USAGE
	#CPU Load:		$CPU_LOAD
	#Last Boot:		$LAST_BOOT
	#LVM Use:		$LVM_USE
	#TCP Connections:	$TCP_CONNECTIONS ESTABLISHED
	#Users:			$CONNECTED_USERS
	#Network:		$NETWORK
	#Sudo:			$SUDO_COMMANDS COMMANDS RAN"
