#!/bin/bash

source ./functions-sys-var.sh
source ./functions-threads.sh

trap this::on_trap EXIT
this::on_trap(){
	{ pkill -P $$; } 2> /dev/null
	sys::var::unset
}

####

this::watcher(){
	sys::var::set cnt 0
	while :; do
		sys::var::get cnt    > "/dev/shm/__cnt.metric"
		sys::var::get cnt5xx > "/dev/shm/__5xx.metric"

                sys::var::set cnt 0
		sys::var::set cnt5xx 0

                sleep 60	# 1 minute agregation
        done
}

threads::run_standalone this::watcher

tail -n 1 -f /var/log/nginx/mtail.log | while IFS='' read line; do

	nginx_resp_status=$( grep -m 1 -oP '(?<=\<status\>)(\d{3})(?=\<\/status\>)' )
	[ $nginx_resp_status -ge 500 -a $nginx_resp_status -le 599 ] && sys::var::inc cnt5xx
	sys::var::inc cnt

done
