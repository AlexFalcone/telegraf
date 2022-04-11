#!/bin/sh
read -p "Enter server name: " SNAME
echo 'export NODENAME='\"${SNAME}\" >> $HOME/.bash_profile
read -p "Enter refresh interval (seconds): " REFRESH
echo 'export NODENAME='\"${REFRESH}\" >> $HOME/.bash_profile
read -p "Enter ip of database: " DBIP
echo 'export NODENAME='\"${DBIP}\" >> $HOME/.bash_profile
read -p "Enter username of database: " DBUSER
echo 'export NODENAME='\"${DBUSER}\" >> $HOME/.bash_profile
read -p "Enter password of database: " DBPASS
echo 'export NODENAME='\"${DBPASS}\" >> $HOME/.bash_profile
source $HOME/.bash_profile
wget -qO- https://repos.influxdata.com/influxdb.key | sudo tee /etc/apt/trusted.gpg.d/influxdb.asc >/dev/null
source /etc/os-release
echo "deb https://repos.influxdata.com/${ID} ${VERSION_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt-get update && sudo apt-get install telegraf
sleep 5
systemctl stop telegraf
var="# Global Agent Configuration
[agent]
  hostname = \"$SNAME\"
  flush_interval = \"$REFRESH\"
  interval = \"$REFRESH\"


# Input Plugins

[[inputs.cpu]]
    percpu = true
    totalcpu = true
    collect_cpu_time = false
    report_active = false
[[inputs.disk]]
    ignore_fs = [\"tmpfs\", \"devtmpfs\", \"devfs\"]
[[inputs.io]]
[[inputs.mem]]
[[inputs.net]]
[[inputs.system]]
[[inputs.swap]]
[[inputs.netstat]]
[[inputs.processes]]
[[inputs.kernel]]

# Output Plugin InfluxDB
[[outputs.influxdb]]
  database = \"metrics\"
  urls = [ \"http://$DBIP:8086\" ]
  username = \"$DBUSER\"
  password = \"$DBPASS\" 
"
echo "$var"
echo "$var" > "telegraf.conf"
sleep 5
telegraf --config telegraf.conf
f
