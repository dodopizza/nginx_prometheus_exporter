#!/bin/bash

while true ; do nc -l -p 1906 -e ./response.sh; done
