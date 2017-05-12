#!/bin/bash
timerL=$SECONDS
timer=0
uuid=$(uuidgen)

trap this::on_trap EXIT

sys::var::set(){
	local key=$1
	local val=$2
	echo "${val}" > "/dev/shm/${uuid}-${key}"
}

sys::var::get(){
	local key=$1
        cat "/dev/shm/${uuid}-${key}"
}

sys::var::inc(){
	local key=$1
	local val=$(sys::var::get $key)
        ((val++))
	sys::var::set $key $val
}

sys::var::killall(){
	rm -f "/dev/shm/${uuid}-*"
}

this::on_trap(){
	 #pkill -P $$
	kill $this__pid__watcher
	sys::var::killall
}


sys::var::set cnt 0

{ 
	while true; do
		sys::var::get cnt
		sys::var::set cnt 0
		sleep 5
	done
}&
this__pid__watcher=$!

tail -f /var/log/nginx/access.log | while IFS='' read line; do
	sys::var::inc cnt
done
