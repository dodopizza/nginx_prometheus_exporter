#!/bin/bash

sys__var__unique=$(uuidgen)
sys__var__prefix="/dev/shm/${sys__var__unique}"

global(){
        sys::var $@
}

sys::var(){
	local fvar="${sys__var__prefix}-${1}"

        if [ ! -z ${2:-} ]; then
        # set variable
                echo $2 > $fvar
        else
        # get variable
        	[ -f $fvar ] && echo $(<$fvar) || echo ""
        fi
}

sys::var::inc(){
        local fvar="${sys__var__prefix}-${1}"
        expr $(<$fvar) + 1 > $fvar
}

sys::var::unset(){
        rm -f "${sys__var__prefix}*"
}
