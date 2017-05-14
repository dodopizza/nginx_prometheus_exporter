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
                local m5xx=$( sys::var::get cnt )
		echo $m5xx > "/dev/shm/__5xx.metric"

                sys::var::set cnt 0
                sleep 3
        done
}

threads::run_standalone this::watcher

tail -n 1 -f /var/log/nginx/access.log | while IFS='' read line; do

	local status=$( grep -m 1 -oP '(?<=\<status\>)(\d{3})(?=\<\/status\>)' )
	echo status
	sys::var::inc cnt
done
