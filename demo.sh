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
## Traffic Generator
############################################################################

echo -e "Connecting to ${BLUE}http://${VIP_DVWA}/login.php${RESTORE} username=${BLUE}pablo${RESTORE} password=${BLUE}letmein${RESTORE}"
curl "http://${VIP_DVWA}/login.php" \
    -H "authority: ${VIP_DVWA}" \
    -H "cache-control: max-age=0" \
    -H "content-type: application/x-www-form-urlencoded" \
    -H "origin: http://${VIP_DVWA}" \
    -H "referer: http://${VIP_DVWA}" \
    -H "user-agent: FortiADC Demo Script" \
    --insecure \
    --data-raw "username=pablo&password=letmein&Login=Login" \
    -c cookie.txt

if [ $? -eq 0 ]; then
    echo "Connection was successful"
else
    echo "Connection failed"
fi

grep PHPSESSID cookie.txt

echo -e "Connecting to ${BLUE}http://${VIP_DVWA}/vulnerabilities/exec/${RESTORE}\n"
curl "http://${VIP_DVWA}/vulnerabilities/exec/" \
    -H "authority: ${VIP_DVWA}" \
    -H "cache-control: max-age=0" \
    -H "content-type: application/x-www-form-urlencoded" \
    -H "origin: http://${VIP_DVWA}" \
    -H "referer: http://${VIP_DVWA}/index.php" \
    -H "user-agent: FortiADC Demo Script" \
    --insecure \
    --data-raw "localhost" \
    -b cookie.txt 

if [ $? -eq 0 ]; then
    echo "Connection was successful"
else
    echo "Connection failed"
fi