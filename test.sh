#!/bin/bash

do_curl() {
    local HOST=$1
    echo "$HOST"
    if true
    then
        curl -k https://"$HOST"
    fi
}

do_curl "perdu.com"
