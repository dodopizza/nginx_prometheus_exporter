#!/bin/bash

THREADS__FIFO_FILE=./history
THREADS__PIDS=()
THREADS__LAST_PID=0

# threads::kill <PID>
threads::kill() {
        kill -9 ${1} 2>/dev/null
        wait ${1} 2>/dev/null
}


threads::last_pid(){
	echo $THREADS__LAST_PID
}

# threads::run_standalone <arg1> .. [argN]
threads::run_standalone() {
	{
		{ # try
			$@
		} 2> >(log) || { #catch
			echo 'Error 1: Error in thread'
			exit 2
		}
	}&
	THREADS__LAST_PID=$! # PID
}
