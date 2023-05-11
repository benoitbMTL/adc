#!/bin/bash

do_curl() {
    local HOST=$1
    echo "$HOST"
    curl -k https://"$HOST"
}

do_curl "perdu.com"
