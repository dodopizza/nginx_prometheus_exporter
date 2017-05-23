#!/bin/bash
source ./counters.common.sh

log=/var/log/nginx/mtail.log
SECONDS=0

while 
	lastp=`get_file_size $log`
	segment=`tail -c +$lastp $log`
do
	if [ $SECONDS -ge 60 ]; then 
		echo ${metric[nginx_total]}; echo ${metric[nginx_5xx]}
		SECONDS=0
		metric::write nginx_total
	        metric::write nginx_5xx
		metric[nginx_total]=0
		metric[nginx_5xx]=0
	fi

	for line in $segment; do
		[ -z $line ] && continue; # if empty

		metric::inc nginx_total

		nginx_status=`echo $line | grep -m 1 -oP '(?<=\<status\>)(\d{3})(?=\<\/status\>)'`
		if [ -z $nginx_status ]; then continue; fi
		if [ $nginx_status -gt 500 -a $nginx_status -le 599 ]; then metric::inc nginx_5xx; fi
	done
done
