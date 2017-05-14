#!/bin/bash
trap httpd::on_trap EXIT
httpd::on_trap(){ 
	{ pkill -P $$; } 2> /dev/null
	rm -f "/dev/shm/__*.metric"
	echo "Shutting down httpd"
}

echo "Running counter"
source ./counter.sh &	# Running in BG

echo "Running httpd"
while true ; do nc -l -p 1906 -e ./response.sh; done
