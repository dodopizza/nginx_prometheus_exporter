#!/bin/bash

function get_file_size(){
	wc -c $1 | awk '{print $1}'
}

declare -A metric

function metric::write(){
	echo ${metric[$1]}  > "/dev/shm/${1}.metric"
}

function metric::inc(){
	(( metric[$1]++ ))
}
