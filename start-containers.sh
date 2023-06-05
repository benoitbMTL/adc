# bbuonassera June 5th, 2023
# ADC demo
# Start Stopped Containers
#!/bin/bash

# List all docker images
echo "Available Docker Images:"
sudo docker images

# Get the IDs of all stopped containers
echo "IDs of all stopped containers:"
stopped_containers=$(sudo docker ps -a -f status=exited -q)
echo stopped_containers

# If there are any stopped containers, start them
if [ -n "$stopped_containers" ]; then
    echo "Starting stopped containers..."
    for container in $stopped_containers; do
        sudo docker start $container
    done
else
    echo "No stopped containers found."
fi