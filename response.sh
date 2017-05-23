#!/bin/bash
response="HTTP/1.1 200 OK\n\n"

prometheus::gauge::set(){
	local m_name=$1
	local m_descr=$2
	local m_value=$3
	response="${response}# HELP ${m_name} ${m_descr}\n# TYPE ${m_name} gauge\n${m_name} ${m_value}\n"
}

nginx::get_active_connections(){
	curl --silent  http://127.0.0.1/nginx-stats 2>&1 | grep -m 1 -oP '(?<=Active connections: )(\d+)'
}

sys::timestamp(){
	date +%s
}

prometheus::gauge::set nginx_server_timestamp "Nginx server timestamp" `sys::timestamp`
prometheus::gauge::set nginx_active_connections "Nginx active connections" `nginx::get_active_connections`
prometheus::gauge::set nginx_server_requests "Nginx requests/minute" `cat "/dev/shm/nginx_total.metric"`
prometheus::gauge::set nginx_server_5xx "Nginx 5xx/minute" `cat "/dev/shm/nginx_5xx.metric"`

echo -e "${response}"
