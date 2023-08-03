
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Cassandra connection timeouts incident
---

This incident refers to a situation where there are connection timeouts between nodes in a Cassandra cluster, resulting in a high level of urgency. The incident is triggered automatically by an alert system and assigned to an engineer for resolution. It requires immediate attention as it can potentially impact the availability and performance of the Cassandra service.

### Parameters
```shell
# Environment Variables

export NODE_IP_ADDRESS="PLACEHOLDER"

export TIMEOUT_VALUE_FOR_PING_COMMAND="PLACEHOLDER"

export PATH_TO_CASSANDRA_LOG_FILE="PLACEHOLDER"

export NODE_NAME="PLACEHOLDER"

export PORT_NUMBER="PLACEHOLDER"
```

## Debug

### Check Cassandra service status
```shell
systemctl status cassandra
```

### Check Cassandra cluster status
```shell
nodetool status
```

### Check if there are any network issues
```shell
ping ${NODE_IP_ADDRESS}
```

### Check if there are any Cassandra connection issues
```shell
cqlsh ${NODE_IP_ADDRESS}
```

### Check Cassandra logs for any errors or warnings related to timeouts
```shell
tail -f /var/log/cassandra/system.log | grep timeout
```

### Check for any Cassandra nodetool errors or warnings related to timeouts
```shell
nodetool tpstats | grep Timeouts
```

### Network connectivity issues between nodes in the Cassandra cluster.
```shell


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


```

## Repair

### Identify the root cause of the connection timeouts
```shell
echo "Checking system logs for hardware or network failures..."

grep -i "error" /var/log/syslog
```

### Restart the Cassandra nodes that are causing the timeouts and monitor the system for any improvements.
```shell


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


```