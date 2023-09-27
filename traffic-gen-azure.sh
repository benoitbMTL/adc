# bbuonassera June 5th, 2023
# ADC demo
# Random Traffic Generator
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
VIP_DVWA="dvwa.canadaeast.cloudapp.azure.com"
VIP_MYAPP="myapp.canadaeast.cloudapp.azure.com"
USER_AGENT="FortiADC Demo Script"
COOKIE="cookie.txt"

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
        #echo "Cookie file does not exist: $COOKIE_FILE"
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
        #echo "Cookie file does not exist: $COOKIE_FILE"
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
    local COOKIE_ACTION=$6  # "read", "write", or "none"

    # Debug
    if [ -n "$DATA_RAW" ]; then
        echo -e "curl ${BLUE}http://${HOST}/${URL_PATH}${RESTORE} --data-raw ${RED}${DATA_RAW}${RESTORE}"
    else
        echo -e "curl ${BLUE}http://${HOST}/${URL_PATH}${RESTORE}"
    fi

# Base curl command without -b or -c
    local CURL_CMD="curl -L -k -s -o /dev/null \"http://${HOST}/${URL_PATH}\" \
        -H \"authority: ${HOST}\" \
        -H \"cache-control: max-age=0\" \
        -H \"content-type: application/x-www-form-urlencoded\" \
        -H \"origin: http://${HOST}\" \
        -H \"referer: http://${HOST}/${REFERER}\" \
        -H \"user-agent: FortiADC Demo Script\""

    # Add -b or -c to the curl command if a cookie file was provided
    if [ -n "$COOKIE_FILE" ]; then
        case "$COOKIE_ACTION" in
            read)
                CURL_CMD+=" --data-raw \"${DATA_RAW}\""
                CURL_CMD+=" -b \"$COOKIE_FILE\""
                ;;
            write)
                CURL_CMD+=" --data-raw \"${DATA_RAW}\""
                CURL_CMD+=" -c \"$COOKIE_FILE\""
                ;;
        esac
    fi

    # Run the curl command
    #echo $CURL_CMD
    eval $CURL_CMD

    # Check the exit status of the curl command
    if [ $? -eq 0 ]; then
        echo -e "Connection to $HOST was ${GREEN}successful${RESTORE}"
    else
        echo -e "Connection to $HOST ${RED}failed${RESTORE}"
    fi

    # Print the cookie value
    print_cookie "$COOKIE_FILE"

    random_number=$((RANDOM % 5 + 1))
    echo "Sleeping for $random_number seconds..."
    sleep $random_number

}

############################################################################
## Traffic Generator
############################################################################

    # Store start time
    start_time=$(date +%s)

    # Define duration (in seconds) for 1 hour
    duration=$((60 * 60)) 

while true ; do

    # Get current time
    current_time=$(date +%s)
    
    # Calculate elapsed time
    elapsed_time=$((current_time - start_time))

    # Break loop if duration has elapsed
    if (( elapsed_time >= duration )); then
        break
    fi

    do_curl "${VIP_DVWA}" "login.php" "" "username=pablo&password=letmein&Login=Login" "${COOKIE}" "write"
    do_curl "${VIP_DVWA}" "vulnerabilities/exec/" "index.php" "localhost" "${COOKIE}" "read"
    delete_cookie "${COOKIE}"

    do_curl "${VIP_DVWA}" "login.php" "" "username=gordonb&password=abc123&Login=Login" "${COOKIE}" "write"
    do_curl "${VIP_DVWA}" "vulnerabilities/sqli/?id=%27OR+1%3D1%23&Submit=Submit" "index.php" "localhost" "${COOKIE}" "read"
    delete_cookie "${COOKIE}"

    do_curl "${MYAPP}"

done
