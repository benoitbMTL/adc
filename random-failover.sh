# bbuonassera June 5th, 2023
# ADC demo
# Random Docker failover
#!/bin/bash

function start_stopped_containers() {
    # List all docker images
    echo "Available Docker Images:"
    sudo docker images

    # Get the IDs of all stopped containers
    stopped_containers=$(sudo docker ps -a -f status=exited -q)

    # If there are any stopped containers, start them
    if [ -n "$stopped_containers" ]; then
        echo "Starting stopped containers..."
        for container in $stopped_containers; do
            sudo docker start $container
        done
    else
        echo "No stopped containers found."
    fi
}

# Store start time
start_time=$(date +%s)

# Define duration (in seconds) for 1 hour
duration=$((60 * 60)) 

while true; do

    # Get current time
    current_time=$(date +%s)
    
    # Calculate elapsed time
    elapsed_time=$((current_time - start_time))

    # Break loop if duration has elapsed
    if (( elapsed_time >= duration )); then
        start_stopped_containers
        break
    fi

    # Get all Docker container IDs, image names, and status
    echo "Getting Docker container IDs, image names, and status..."
    CONTAINER_INFO=$(sudo docker ps -a --format "{{.ID}} {{.Image}} {{.Status}}")
    echo "$CONTAINER_INFO"

    # Convert the IDs into an array
    CONTAINER_ARRAY=($(echo "$CONTAINER_INFO" | awk '{print $1}'))

    # Get the array length
    ARRAY_LENGTH=${#CONTAINER_ARRAY[@]}

    # Select a random index
    RANDOM_INDEX=$((RANDOM%ARRAY_LENGTH))

    # Get the ID of the randomly selected container
    RANDOM_CONTAINER_ID=${CONTAINER_ARRAY[$RANDOM_INDEX]}
    RANDOM_CONTAINER_IMAGE=$(echo "$CONTAINER_INFO" | grep "^$RANDOM_CONTAINER_ID" | awk '{print $2}')

    echo "Randomly selected container ID: $RANDOM_CONTAINER_ID, Image: $RANDOM_CONTAINER_IMAGE"

    # Stop the container
    echo "Stopping the container $RANDOM_CONTAINER_ID, Image: $RANDOM_CONTAINER_IMAGE"
    sudo docker stop $RANDOM_CONTAINER_ID

    # Sleep for 1 minute
    echo "Sleeping for 1 minute..."
    for i in {60..1}; do
        echo -ne "$i\033[0K\r"
        sleep 1
    done

    # Start the container
    echo "Starting the container $RANDOM_CONTAINER_ID, Image: $RANDOM_CONTAINER_IMAGE"
    sudo docker start $RANDOM_CONTAINER_ID

    # Sleep for 2 minutes
    # echo "Sleeping for 2 minutes..."
    # for i in {120..1}; do
    #     echo -ne "$i\033[0K\r"
    #     sleep 1
    # done
done