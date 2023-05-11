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

do_curl() {
    local HOST=$1
    local PATH=$2
    local REFERER=$3
    local DATA_RAW=$4

    # Debug
    echo "curl http://${HOST}/${PATH} --data-raw ${DATA_RAW}"

    # Use curl to try to connect
    /usr/bin/curl -s -o /dev/null "http://${HOST}/${PATH}" \
        -H "authority: ${HOST}" \
        -H "cache-control: max-age=0" \
        -H "content-type: application/x-www-form-urlencoded" \
        -H "origin: http://${HOST}" \
        -H "referer: http://${HOST}/${REFERER}" \
        -H "user-agent: ${USER_AGENT}" \
        --insecure \
        --data-raw "${DATA_RAW}" \
        -c cookie.txt

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

do_curl "${VIP_DVWA}" "login.php" "" "username=pablo&password=letmein&Login=Login"
grep PHPSESSID cookie.txt
do_curl "${VIP_DVWA}" "vulnerabilities/exec/" "index.php" "localhost"
grep PHPSESSID cookie.txt
