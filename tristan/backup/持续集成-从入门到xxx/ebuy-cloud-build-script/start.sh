#!/bin/bash
applicationName='wpmanager'
for file in lib/*; 
	do cp=${cp}:$file; 
done 
PID=$(cat /var/run/${applicationName}.pid)
gpid=`ps -fe|grep $PID |grep -v grep`
if [ "$?" != "0" ]
then 
	nohup java -jar  ${applicationName}.jar > nohup.out 2>&1 &
	sleep 1s
	echo $! > /var/run/${applicationName}.pid
	cpid=`ps -fe|grep $! |grep -v grep`
	if [ ! "${cpid}" ]
	then 
		echo ${applicationName}' Start Failed'
	else
		echo ${applicationName}' Start Success'
	fi
else
echo ${applicationName}' is already start'
fi
