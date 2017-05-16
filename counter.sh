#!/bin/bash

source ./functions.sh
source ./functions-sys-var.sh
source ./functions-threads.sh

trap this::on_trap EXIT
this::on_trap(){
	{ pkill -P $$; } 2> /dev/null
	sys::var::unset
}

####

this::watcher(){
	global cnt 0
	while :; do
		global cnt    > "/dev/shm/__cnt.metric"
		global cnt5xx > "/dev/shm/__5xx.metric"

		log `global cnt`

                global cnt 0
		global cnt5xx 0

                sleep 2 # 1 minute agregation
        done
}

log "Starting collector"
threads::run_standalone this::watcher

while :; do
	log "Starting new log rotation"
	tail -n 1 -f /var/log/nginx/mtail.log | while IFS='' read line; do

		nginx_resp_status=$( grep -m 1 -oP '(?<=\<status\>)(\d{3})(?=\<\/status\>)' )
		[ $nginx_resp_status -ge 500 -a $nginx_resp_status -le 599 ] && sys::var::inc cnt5xx
		sys::var::inc cnt

	done
done
