#!/bin/bash

this::metrics::set(){

        if [[ ! -f ./tmp ]]; then
                declare -A script__metrics
        fi
        local key=$1
        local val=$2
        local content="declare -A script__metrics\n"
        script__metrics[$key]=$val

        for k in "${!script__metrics[@]}"
        do
                local content="${content}script__metrics[\"${k}\"]=\"${script__metrics[$k]}\"\n"
        done
        echo -e $content > ./tmp
}

this::metrics::get(){
        local key=$1
        source ./tmp
        echo ${script__metrics["${key}"]}
}

#this::metrics::set one two
#this::metrics::set two 123
#this::metrics::get one
#exit
