#!/bin/bash

sys__var__uuid=$(uuidgen)
sys__var__prefix="/dev/shm/${sys__var__uuid}"
#echo $sys__var__prefix

sys::var::set(){
        local key=$1
        local val=$2
	local kvname="${sys__var__prefix}-${key}"
        echo "${val}" > "${kvname}"
}

sys::var::get(){
        local key=$1
	local kvname="${sys__var__prefix}-${key}"

	if [[ -f $kvname ]]; then
		cat "${kvname}"
        else
		echo ""
	fi
}

sys::var::inc(){
        local key=$1
	local kvname="${sys__var__prefix}-${key}"
	echo $(($(<"${kvname}")+1)) >"${kvname}";
}

sys::var::unset(){
	rm -f "${sys__var__prefix}*"
}
