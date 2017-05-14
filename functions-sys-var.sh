#!/bin/bash

sys__var__uuid=$(uuidgen)
sys__var__prefix="/dev/shm/${sys__var__uuid}"

sys::var::set(){
        local key=$1
        local val=$2
	local kvname="${sys__var__prefix}-${key}"
        echo "${val}" > "${kvname}"
}

sys::var::get(){
        local key=$1
	local kvname="${sys__var__prefix}-${key}"
	[[ -f "${kvname}" ]] && cat "${kvname}" || echo ""
}

sys::var::inc(){
        local key=$1
        local val=$(sys::var::get $key)
        ((val++))
        sys::var::set $key $val
}

sys::var::unset(){
	rm -f "${sys__var__prefix}*"
}
