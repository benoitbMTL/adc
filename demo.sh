# bbuonassera May 11th, 2023
# ADC demo
#!/bin/bash

###############################################
## Ensure we are running under bash
###############################################
if [ "$BASH_SOURCE" = "" ]; then
    /bin/bash "$0"
    exit 0
fi

###############################################
## Set Variables
###############################################
VIP_DVWA="10.163.7.32"
VIP_PETSTORE="10.163.7.33"
VIP_SPEEDTEST="10.163.7.34"
VIP_SHOP="10.163.7.35"
VIP_HELLO="10.163.7.36"
VIP_FINANCE="10.163.7.37"
USER_AGENT="FortiADC Demo Script"

############################################################################
## Colors
############################################################################
BOLD='\033[1m'
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'


############################################################################
## DELETE COOKIE
############################################################################
delete_cookie() {
    local COOKIE_FILE=$1

    if [ ! -f "$COOKIE_FILE" ]; then
        echo "Cookie file does not exist: $COOKIE_FILE"
        return 1
    fi

    rm $COOKIE_FILE
}

############################################################################
## PRINT COOKIE
############################################################################
print_cookie() {
    local COOKIE_FILE=$1

    if [ ! -f "$COOKIE_FILE" ]; then
        echo "Cookie file does not exist: $COOKIE_FILE"
        return 1
    fi

    grep "PHPSESSID" "$COOKIE_FILE" | awk 'NF{print $1 " --> " $6 "=" $7}'
}


############################################################################
## EXECUTE CURL
############################################################################
do_curl() {
    local HOST=$1
    local URL_PATH=$2
    local REFERER=$3
    local DATA_RAW=$4
    local COOKIE_FILE=$5

    # Debug
    echo "curl http://${HOST}/${URL_PATH} --data-raw ${DATA_RAW}"

    if [ ! -f "$COOKIE_FILE" ]; then
        # Use curl to try to connect and create a new cookie file
        curl -s -o /dev/null "http://${HOST}/${URL_PATH}" \
            -H "authority: ${HOST}" \
            -H "cache-control: max-age=0" \
            -H "content-type: application/x-www-form-urlencoded" \
            -H "origin: http://${HOST}" \
            -H "referer: http://${HOST}/${REFERER}" \
            -H "user-agent: FortiADC Demo Script" \
            --insecure \
            --data-raw "${DATA_RAW}" \
            -c "$COOKIE_FILE"
    else
        # Use curl to try to connect and use the existing cookie file
        curl -s -o /dev/null "http://${HOST}/${URL_PATH}" \
            -H "authority: ${HOST}" \
            -H "cache-control: max-age=0" \
            -H "content-type: application/x-www-form-urlencoded" \
            -H "origin: http://${HOST}" \
            -H "referer: http://${HOST}/${REFERER}" \
            -H "user-agent: FortiADC Demo Script" \
            --insecure \
            --data-raw "${DATA_RAW}" \
            -b "$COOKIE_FILE"
    fi

    print_cookie "$COOKIE_FILE"

    # Check the exit status of the curl command
    if [ $? -eq 0 ]; then
        echo "Connection to $HOST was successful"
    else
        echo "Connection to $HOST failed"
    fi
}


############################################################################
## Traffic Generator
############################################################################

do_curl "${VIP_DVWA}" "login.php" "" "username=pablo&password=letmein&Login=Login" "cookie.txt"
do_curl "${VIP_DVWA}" "vulnerabilities/exec/" "index.php" "localhost" "cookie.txt"
delete_cookie "cookie.txt"

do_curl "${VIP_DVWA}" "login.php" "" "username=gordonb&password=abc123&Login=Login" "cookie.txt"
do_curl "${VIP_DVWA}" "vulnerabilities/sqli/?id=%27OR+1%3D1%23&Submit=Submit" "index.php" "localhost" "cookie.txt"
delete_cookie "cookie.txt"

do_curl "${VIP_PETSTORE}" ""
do_curl "${VIP_SPEEDTEST}" ""
do_curl "${VIP_SHOP}" ""
do_curl "${VIP_HELLO}" ""
do_curl "${VIP_FINANCE}" "fwb"
