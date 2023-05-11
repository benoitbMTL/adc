#!/bin/bash

do_curl() {
    local HOST=$1
    echo "$HOST"
    if [ true ] ; then
        curl -s -o /dev/null "http://${HOST}" \
            -H "authority: ${HOST}" \
            -H "cache-control: max-age=0" \
            -H "content-type: application/x-www-form-urlencoded" \
            -H "origin: http://${HOST}" \
            -H "referer: http://${HOST}" \
            -H "user-agent: Bonjour" \
            --insecure 
    fi
}

do_curl "perdu.com"
