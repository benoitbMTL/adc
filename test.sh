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
## EXECUTE CURL
############################################################################
do_curl() {
    local HOST=$1
    local PATH=$2
    local REFERER=$3
    local DATA_RAW=$4
    local COOKIE_FILE=$5

    # Debug
    echo "curl http://${HOST}/${PATH} --data-raw ${DATA_RAW}"

    curl -v http://perdu.com
}


############################################################################
## Traffic Generator
############################################################################

do_curl "${VIP_DVWA}" "login.php" "" "username=pablo&password=letmein&Login=Login" "cookie.txt"
do_curl "${VIP_DVWA}" "vulnerabilities/exec/" "index.php" "localhost" "cookie.txt"
