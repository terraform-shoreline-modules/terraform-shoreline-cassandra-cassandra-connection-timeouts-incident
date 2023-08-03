resource "shoreline_notebook" "cassandra_connection_timeouts_incident" {
  name       = "cassandra_connection_timeouts_incident"
  data       = file("${path.module}/data/cassandra_connection_timeouts_incident.json")
  depends_on = [shoreline_action.invoke_check_network_connectivity_and_cassandra_logs,shoreline_action.invoke_log_check,shoreline_action.invoke_bash_node_restart_monitor]
}

resource "shoreline_file" "check_network_connectivity_and_cassandra_logs" {
  name             = "check_network_connectivity_and_cassandra_logs"
  input_file       = "${path.module}/data/check_network_connectivity_and_cassandra_logs.sh"
  md5              = filemd5("${path.module}/data/check_network_connectivity_and_cassandra_logs.sh")
  description      = "Network connectivity issues between nodes in the Cassandra cluster."
  destination_path = "/agent/scripts/check_network_connectivity_and_cassandra_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "log_check" {
  name             = "log_check"
  input_file       = "${path.module}/data/log_check.sh"
  md5              = filemd5("${path.module}/data/log_check.sh")
  description      = "Identify the root cause of the connection timeouts"
  destination_path = "/agent/scripts/log_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "bash_node_restart_monitor" {
  name             = "bash_node_restart_monitor"
  input_file       = "${path.module}/data/bash_node_restart_monitor.sh"
  md5              = filemd5("${path.module}/data/bash_node_restart_monitor.sh")
  description      = "Restart the Cassandra nodes that are causing the timeouts and monitor the system for any improvements."
  destination_path = "/agent/scripts/bash_node_restart_monitor.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_network_connectivity_and_cassandra_logs" {
  name        = "invoke_check_network_connectivity_and_cassandra_logs"
  description = "Network connectivity issues between nodes in the Cassandra cluster."
  command     = "`chmod +x /agent/scripts/check_network_connectivity_and_cassandra_logs.sh && /agent/scripts/check_network_connectivity_and_cassandra_logs.sh`"
  params      = ["PATH_TO_CASSANDRA_LOG_FILE","TIMEOUT_VALUE_FOR_PING_COMMAND","NODE_IP_ADDRESS"]
  file_deps   = ["check_network_connectivity_and_cassandra_logs"]
  enabled     = true
  depends_on  = [shoreline_file.check_network_connectivity_and_cassandra_logs]
}

resource "shoreline_action" "invoke_log_check" {
  name        = "invoke_log_check"
  description = "Identify the root cause of the connection timeouts"
  command     = "`chmod +x /agent/scripts/log_check.sh && /agent/scripts/log_check.sh`"
  params      = []
  file_deps   = ["log_check"]
  enabled     = true
  depends_on  = [shoreline_file.log_check]
}

resource "shoreline_action" "invoke_bash_node_restart_monitor" {
  name        = "invoke_bash_node_restart_monitor"
  description = "Restart the Cassandra nodes that are causing the timeouts and monitor the system for any improvements."
  command     = "`chmod +x /agent/scripts/bash_node_restart_monitor.sh && /agent/scripts/bash_node_restart_monitor.sh`"
  params      = ["NODE_NAME"]
  file_deps   = ["bash_node_restart_monitor"]
  enabled     = true
  depends_on  = [shoreline_file.bash_node_restart_monitor]
}

