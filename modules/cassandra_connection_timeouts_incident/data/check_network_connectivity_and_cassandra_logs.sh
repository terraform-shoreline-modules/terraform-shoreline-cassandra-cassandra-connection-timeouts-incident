

#!/bin/bash



# Set variables

IP_ADDRESS=${NODE_IP_ADDRESS}

PING_TIMEOUT=${TIMEOUT_VALUE_FOR_PING_COMMAND}

CASSANDRA_LOG=${PATH_TO_CASSANDRA_LOG_FILE}



# Check network connectivity

ping -c 3 -W $PING_TIMEOUT $IP_ADDRESS > /dev/null 2>&1

if [ $? -eq 0 ]; then

    echo "Network connectivity between nodes is working fine."

else

    echo "Network connectivity issues detected between nodes."

    echo "Checking Cassandra log file for errors..."

    grep -i "ERROR" $CASSANDRA_LOG

fi