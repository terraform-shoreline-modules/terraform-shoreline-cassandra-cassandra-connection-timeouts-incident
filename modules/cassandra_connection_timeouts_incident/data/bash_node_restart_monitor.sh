

#!/bin/bash



# Set the Cassandra node name and IP address

NODE_NAME=${NODE_NAME}

NODE_IP=${NODE_IP}



# Check if the node is running

if nodetool status | grep $NODE_NAME | grep -q "UN"; then

  echo "Node $NODE_NAME is running and healthy"

else

  echo "Node $NODE_NAME is not running. Starting the node..."

  sudo service cassandra start

fi



# Restart the node

echo "Restarting node $NODE_NAME ($NODE_IP)..."

sudo nodetool drain

sudo service cassandra stop

sudo service cassandra start



# Monitor the system for any improvements

echo "Checking the Cassandra log for any errors..."

tail -n 100 /var/log/cassandra/system.log