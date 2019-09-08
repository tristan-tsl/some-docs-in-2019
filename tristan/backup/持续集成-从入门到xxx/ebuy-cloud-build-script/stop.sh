#!/bin/bash
applicationName='hqbmanager'
PID=$(cat /var/run/${applicationName}.pid)
gpid=`ps -fe|grep $PID |grep -v grep`
if [ "$?" != "0" ]
then 
	echo 'No instance is running'
else
	kill -9 $PID
	echo ${applicationName}' Stop Success'
	exit 0
fi