#!/bin/bash
trap httpd::on_trap EXIT
httpd::on_trap(){ 
	{ pkill -P $$; } 2> /dev/null
	rm -f "/dev/shm/__*.metric"
	echo "Shutting down httpd"
}

for counterscript in ./counters/*.sh
do
	{
		echo "Running counter ${counterscript}"
		$counterscript &
	} || {
		echo "Error in counter"
		exit 1
	}
done

echo "Running httpd"
while true ; do nc -l -p 1906 -e ./response.sh; done
