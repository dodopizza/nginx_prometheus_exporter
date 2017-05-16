#!/bin/bash

## Unofficial bash strict mode
#set -euo pipefail
#IFS=$' \n\t'

## Globales
SCRIPT_NAME=$(basename $0)
SCRIPT_DIR=$(cd $(dirname $0) && pwd) # without ending /
CURRENT_DATE=$(date +%Y-%m-%d)
CURRENT_USER=$(whoami)
TMP_FOLDER=/tmp

_LOGFILE="${SCRIPT_DIR}/logs/${SCRIPT_NAME%.*}-${CURRENT_DATE}.log"
test -f $_LOGFILE || (umask 000; touch $_LOGFILE)



function log {
        local now=$(TZ=UTC-3 date +"%F %T") # UTC+3

        if [ -z ${1+x} ]; then
                read local msg # read from stdin if $1 is empty
        else
                local msg=$1
        fi;

        local msg="[UTC+3][${now}] ${msg}"

        echo -e $msg >> $_LOGFILE

        local refresh=${2:-} # strict mode prevent empty var
        [ "$refresh" == "refresh" ] && echo_current $msg || echo -e $msg

        # Run once
        # if [ -z ${loginit+x} ]; then loginit=1; log "Start logging to ${_LOGFILE}"; fi
}
printf "\n\n\n\n\n\n\n\n\n\n" >> $_LOGFILE; log "Start logging from user ${CURRENT_USER} to ${_LOGFILE}"
